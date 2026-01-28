import 'dart:async';
import 'dart:io';
import 'package:canti_hub/common/app_settings.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/bluetooth_helpers/communication.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider extends ChangeNotifier {
  DatabaseProvider? _dbProvider;
  Communication? com;
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _initialConfigWasSent = false;

  List<BluetoothDevice> get systemDevices => _systemDevices;
  set systemDevices(List<BluetoothDevice> value) {
    _systemDevices = value;
  }

  List<ScanResult> get scanResults => _scanResults;
  set scanResults(List<ScanResult> value) {
    _scanResults = value;
  }

  set dbProvider(DatabaseProvider? dbProvider) {
    _dbProvider = dbProvider;
  }

  void updateDb(DatabaseProvider? dbProvider) {
    _dbProvider = dbProvider;
  }

  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  //used for connected state
  BluetoothDevice? _device;
  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  BluetoothConnectionState get connectionState => _connectionState;
  List<BluetoothService> _services = [];
  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  StreamSubscription<int>? _mtuSubscription;

  BluetoothProvider() {
    FlutterBluePlus.setLogLevel(AppSettings.blLogging, color: true);
  }

  void turnOn() async {
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {}
  }

  void startListentingToAdapterState() {
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      adapterState = state;
      notifyListeners();
    });
  }

  void stopListeningToAdapterState() {
    _adapterStateSubscription?.cancel();
  }

  void startListentingToScanResults() {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    }, onError: (e) {});

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      notifyListeners();
    });
  }

  void stopListeningToScanResults() {
    _scanResultsSubscription?.cancel();
    _isScanningSubscription?.cancel();
  }

  void startScaning() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
      notifyListeners();
    } catch (e) {}
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {}
  }

  void stopScaning() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {}
  }

  void refresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    notifyListeners();
  }

  void connect(BluetoothDevice device) {
    _device = device;
    _device?.connect();
    notifyListeners();
  }

  void disconect() async {
    try {
      await _device?.disconnect();
    } catch (e) {}
  }

  void initConnection() {
    if (_device != null)
      _connectionStateSubscription =
          _device!.connectionState.listen((state) async {
        _connectionState = state;
        if (state == BluetoothConnectionState.connected) {
          _services = []; // must rediscover services
        }
        if (state == BluetoothConnectionState.connected && _rssi == null) {
          _rssi = await _device!.readRssi();
        }
        notifyListeners();
      });

    _mtuSubscription = _device!.mtu.listen((value) {
      _mtuSize = value;
      notifyListeners();
    });
  }

  void disposeDevice() {
    _connectionStateSubscription?.cancel();
    _mtuSubscription?.cancel();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  void discoverServices() async {
    _isDiscoveringServices = true;
    notifyListeners();

    try {
      _services = await _device!.discoverServices();
      com = Communication(_services);
    } catch (e) {}
    _isDiscoveringServices = false;
    notifyListeners();
  }

  BluetoothDevice? _findDevice(DevicesTableData dbDevice) {
    for (BluetoothDevice systemDevice in systemDevices) {
      String remoteId = systemDevice.remoteId.str;
      if (remoteId == dbDevice.remoteId) {
        return systemDevice;
      }
    }

    for (ScanResult scanResult in scanResults) {
      String remoteId = scanResult.device.remoteId.str;
      if (remoteId == dbDevice.remoteId) {
        return scanResult.device;
      }
    }

    return null;
  }

  Future<void> sendConfigurationData() async {
    print('${DateTime.now()} - Starting sendConfigurationData');
    if (_dbProvider == null ||
        com == null ||
        adapterState != BluetoothAdapterState.on) {
      print(
          '${DateTime.now()} - Aborting sendConfigurationData: prerequisites not met');
      return;
    }

    var dbDevices = _dbProvider!.devices;
    if (!_initialConfigWasSent) {
      startListentingToScanResults();
      startScaning();
      print('${DateTime.now()} - Scanning started');
      print('${DateTime.now()} - Initial configuration not sent');
      for (var dbDevice in dbDevices) {
        var device = _findDevice(dbDevice);
        if (device != null) {
          print('${DateTime.now()} - Connecting to device: ${device.remoteId}');
          connect(device);
          initConnection();
          discoverServices();
          await sendRecurrenceToDevice(dbDevice.id);
          await sendAlarmToDevice(dbDevice.id);
          disposeDevice();
          print(
              '${DateTime.now()} - Device configuration completed and disposed: ${device.remoteId}');
        }
      }
      _initialConfigWasSent = true;
      print('${DateTime.now()} - Initial configuration set to true');
    } else {
      startListentingToScanResults();
      startScaning();
      print('${DateTime.now()} - Scanning started');
      for (var dbDevice in dbDevices) {
        var device = _findDevice(dbDevice);
        if (device != null) {
          connect(device);
          initConnection();
          discoverServices();
          if (_dbProvider!.parametersChanged) {
            await sendRecurrenceToDevice(dbDevice.id);
          }
          if (_dbProvider!.alarmsChanged) {
            await sendAlarmToDevice(dbDevice.id);
          }
          disposeDevice();
        }
        if (_dbProvider!.parametersChanged) {
          print('Sent all parameters cahnge');
          _dbProvider!.parametersChanged = false;
        }
        if (_dbProvider!.alarmsChanged) {
          print('Sent all alarm cahnge');
          _dbProvider!.alarmsChanged = false;
        }
      }
      while (_dbProvider!.processDeviceSettingChanges.isNotEmpty) {
        int deviceId = _dbProvider!.processDeviceSettingChanges.removeAt(0);
        var dbDevice = _dbProvider!.devices
            .firstWhere((element) => element.id == deviceId);
        var blDevice = _findDevice(dbDevice);
        if (blDevice != null) {
          print(
              '${DateTime.now()} - Processing queued device setting changes for device: ${blDevice.remoteId}');
          connect(blDevice);
          initConnection();
          discoverServices();
          await sendAlarmToDevice(deviceId);
          await sendRecurrenceToDevice(deviceId);
          disposeDevice();
          print(
              '${DateTime.now()} - Queued device settings updated and device disposed: ${blDevice.remoteId}');
        }
      }
    }
    print('${DateTime.now()} - Completed sendConfigurationData');
  }

  Future<void> sendAlarmToDevice(int deviceId) async {
    var deviceAlarms =
        _dbProvider!.deviceAlarms.where((alarm) => alarm.deviceId == deviceId);
    for (var reference in deviceAlarms) {
      var alarm = _dbProvider!.alarms
          .firstWhere((alarm) => alarm.id == reference.alarmId);
      var alarmParameters = _dbProvider!.alarmParameters
          .where((alarmParameter) => alarm.id == alarmParameter.alarmId);
      for (var alarmParameter in alarmParameters) {
        await com!.sendAlarmSettingCommand(
            reference.slot,
            alarmParameter.parameterId,
            alarmParameter.triggerType,
            alarmParameter.lowerValue ?? 0.0,
            alarmParameter.upperValue ?? 0.0);
        print(
            'Sent alarm setting to device $deviceId: slot ${reference.slot}, parameterId ${alarmParameter.parameterId}, triggerType ${alarmParameter.triggerType}, lowerValue ${alarmParameter.lowerValue ?? 0.0}, upperValue ${alarmParameter.upperValue ?? 0.0}');
      }
      if (alarm.activated == true) {
        print('Alarm was enabled');
        com!.sendEnableAlarmCommand(reference.slot);
      } else {
        print('Alarm was disabled');
        com!.sendDisableAlarmCommand(reference.slot);
      }
    }
  }

  Future<void> sendRecurrenceToDevice(int deviceId) async {
    var deviceParameters = _dbProvider!.deviceParameters
        .where((param) => param.deviceId == deviceId && param.useUserConfig);
    for (var param in deviceParameters) {
      var parameter = _dbProvider!.parameters
          .firstWhere((parameter) => parameter.index == param.parameterId);
      await com!.sendRecurrenceCommand(param.parameterId, parameter.recurrence);
      print(
          'Sent recurrence to device $deviceId: parameterId ${param.parameterId}, recurrence ${parameter.recurrence}');
    }
  }

  void readCollectedData() {
    if (_dbProvider != null) {
      if (_dbProvider!.database != null) {
        if (adapterState == BluetoothAdapterState.on) {
          startListentingToScanResults();
          startScaning();
          var devices = _dbProvider!.devices;
          Future.delayed(Duration(seconds: 1), () {
            devices.forEach((dbDevice) async {
              var device = _findDevice(dbDevice);

              if (device != null) {
                connect(device);
                initConnection();
                _dbProvider!.updateDevice(
                    dbDevice.copyWith(lastOnline: DateTime.now()));
                var deviceParameters = _dbProvider!.deviceParameters;
                await Future.delayed(Duration(seconds: 1));
                discoverServices();
                await Future.delayed(Duration(seconds: 1));
                for (var param in deviceParameters) {
                  var index = param.parameterId;
                  var value = await com!.readParameterValue(index);
                  if (value != null) {
                    _dbProvider!.insertCollectedData(
                      ColectedDataTableCompanion.insert(
                        parameterId: index,
                        deviceId: dbDevice.id,
                        value: value,
                      ),
                    );
                  }
                }

                disposeDevice();
                stopListeningToScanResults();
                stopScaning();
              }
            });
          });
        }
      }
    }
  }
}
