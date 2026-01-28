import 'package:canti_hub/database/custom_types.dart';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class MqttParameter {
  final int id;
  final int index;
  final String name;
  bool checkbox;
  String topic;

  MqttParameter({
    required this.id,
    required this.index,
    required this.name,
    required this.checkbox,
    required this.topic,
  });
}

class DeviceProvider with ChangeNotifier {
  DatabaseProvider? _dbProvider;
  late DeviceType _deviceType;
  late MqttTableData _mqtt;
  late List<MqttParameter> parameters;
  late String _name = '';
  late BluetoothDevice _device =
      BluetoothDevice(remoteId: DeviceIdentifier('0'));
  int? _id;

  DeviceProvider() {
    _deviceType = DeviceType.bluetooth;
    _mqtt = MqttTableData(
        id: -1, serverUrl: 'uninitialized', username: 'uninitialized');
    parameters = [];
  }

  void updateDb(DatabaseProvider? dbProvider) {
    _dbProvider = dbProvider;
  }

  DeviceType get deviceType => _deviceType;
  MqttTableData get mqtt => _mqtt;
  String get name => _name;
  BluetoothDevice get device => _device;

  int get id => _id ?? 0;
  set id(int id) {
    _id = id;
    notifyListeners();
  }

  int? getId() {
    return _id;
  }

  set device(BluetoothDevice device) {
    _device = device;
    notifyListeners();
  }

  set deviceType(DeviceType newDeviceType) {
    _deviceType = newDeviceType;
    notifyListeners();
  }

  set mqtt(MqttTableData newMqtt) {
    _mqtt = newMqtt;
    notifyListeners();
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  void loadParameters() {
    List<MqttParameter> tmpParameters = [];
    if (_dbProvider != null) {
      for (var index = 0;
          index < _dbProvider!.parameters.length;
          index++) {
        var parameter = _dbProvider!.parameters[index];

        // Now you can access parameter.index, parameter.name, etc.
        tmpParameters.add(MqttParameter(
          id: parameter.index,
          index: index,
          name: parameter.name,
          checkbox: false,
          topic: '\${USERNAME}/feeds/\${PARAMETER}',
        ));
      }
    }
    parameters = tmpParameters;
  }

  Future<int> save() async {
    int id = 999;
    if (deviceType == DeviceType.mqtt) {
      if (_dbProvider != null) {
        id = await _dbProvider!.insertDevice(DevicesTableCompanion.insert(
          type: deviceType,
          remoteId: '',
          name: 'mqtt',
          displayNmae: 'mqtt',
          softwareVersion: 'mqtt',
          hardwareVersion: 'mqtt',
          firstConnection: DateTime.now(),
          lastOnline: DateTime.now(),
        ));

        Map<String, String> replacements = {
          'USERNAME': mqtt.username,
          'PARAMETER': '',
        };

        for (var parameter in parameters) {
          replacements['PARAMETER'] = parameter.name;
          parameter.topic = _replacePlaceholders(parameter.topic, replacements);
          print(parameter.topic);
        }
      }
    } else if (deviceType == DeviceType.bluetooth) {
      if (_dbProvider != null) {
        var devicesList = _dbProvider!.devices;
        DevicesTableData? existingDevice = null;
        try {
          existingDevice = devicesList
              .firstWhere((device) => device.remoteId == _device.remoteId.str);
        } catch (e) {}
        if (existingDevice == null) {
          id = await _dbProvider!.insertDevice(DevicesTableCompanion.insert(
            type: deviceType,
            remoteId: _device.remoteId.str,
            name: device.platformName,
            displayNmae: _name == '' ? device.platformName : _name,
            softwareVersion: 'bluetooth',
            hardwareVersion: 'bluetooth',
            firstConnection: DateTime.now(),
            lastOnline: DateTime.now(),
          ));
          print("inserted device with id ${_id}");
        }
      }
    }
    _id = id;
    clean();
    return id;
  }

  void clean() {
    _deviceType = DeviceType.bluetooth;
    _mqtt = MqttTableData(
      id: -1,
      serverUrl: 'uninitialized',
      username: 'uninitialized',
    );
    name = '';

    // Reset boolean value and topic for each parameter
    parameters.forEach((parameter) {
      parameter.checkbox = false;
      parameter.topic = '\${USERNAME}/feeds/\${PARAMETER}';
    });
    notifyListeners();
  }

  String _replacePlaceholders(String input, Map<String, String> replacements) {
    String result = input;
    replacements.forEach((key, value) {
      if (result.contains('\${$key}')) {
        result = result.replaceAll('\${$key}', value);
      } else {
        result = result.replaceAll('\${$key}', '<!-- ${key} is missing -->');
      }
    });
    return result;
  }
}
