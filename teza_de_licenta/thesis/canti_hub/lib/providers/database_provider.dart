import 'dart:async';
import 'package:canti_hub/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DatabaseProvider extends ChangeNotifier {
  Database? _database;
  int? _selectedDeviceIndex;
  List<DevicesTableData>? _devices;
  List<ParametersTableData>? _parameters;
  List<ColectedDataTableData>? _collectedData;
  List<DeviceWifiTableData>? _deviceWifi;
  List<WifiTableData>? _wifi;
  List<MqttTableData>? _mqtt;
  List<MqttParameterTableData>? _mqttParameters;
  List<DeviceParameterTableData>? _deviceParameters;
  List<AlarmsTableData>? _alarms;
  List<DeviceAlarmsTableData>? _deviceAlarms;
  List<AlarmsParameterTableData>? _alarmParameters;

  List<DevicesTableData> get devices => _devices ?? [];
  List<ParametersTableData> get parameters => _parameters ?? [];
  List<ColectedDataTableData> get collectedData => _collectedData ?? [];
  List<DeviceWifiTableData> get deviceWifi => _deviceWifi ?? [];
  List<WifiTableData> get wifi => _wifi ?? [];
  List<MqttTableData> get mqtt => _mqtt ?? [];
  List<MqttParameterTableData> get mqttParameters => _mqttParameters ?? [];
  List<DeviceParameterTableData> get deviceParameters =>
      _deviceParameters ?? [];
  List<AlarmsTableData> get alarms => _alarms ?? [];
  List<DeviceAlarmsTableData> get deviceAlarms => _deviceAlarms ?? [];
  List<AlarmsParameterTableData> get alarmParameters => _alarmParameters ?? [];

  Database? get database => _database;
  List<int> _invalidDeviceId = [];
  List<int> processDeviceSettingChanges = [];
  bool parametersChanged = true;
  bool alarmsChanged = true;

  DatabaseProvider() {
    Future.microtask(() {
      _database = Database();
      _database!.customStatement('PRAGMA foreign_keys = ON');

      getAll();

      notifyListeners();
    });
  }

  void getAll() async {
    getAllDevices();
    getAllParameters();
    getLatestCollectedData();
    getAllDeviceWifi();
    getAllWifi();
    getAllMqtt();
    getAllMqttParameters();
    getAllDeviceParameters();
    getAllAlarms();
    getAllDeviceAlarms();
    getAllAlarmParameters(0);
  }

  int? get selectedDeviceIndex => _selectedDeviceIndex;
  set selectedDeviceIndex(int? index) {
    _selectedDeviceIndex = index;
    notifyListeners();
  }

  ColectedDataTableData? getData(int deviceId, int parameterId) {
    if (_collectedData == null) {
      return null;
    }
    if (_collectedData!.isEmpty) {
      return null;
    }

    try {
      return _collectedData?.firstWhere((data) =>
          data.deviceId == deviceId && data.parameterId == parameterId);
    } catch (e) {
      return null;
    }
  }

  ParametersTableData? getParameterByIndex(int index) {
    return _parameters?.firstWhere((parameter) => parameter.index == index);
  }

  // DevicesTable
  Future<int> insertDevice(DevicesTableCompanion device) async {
    int id = await _database!.into(_database!.devicesTable).insert(device);
    notifyListeners();
    await getAllDevices();
    return id;
  }

  Future<void> getAllDevices() async {
    _devices = await _database!.select(_database!.devicesTable).get();
    _selectedDeviceIndex = _devices!.isNotEmpty ? 0 : null;
    notifyListeners();
  }

  Future<void> updateDevice(DevicesTableData device) async {
    await _database!.update(_database!.devicesTable).replace(device);
    notifyListeners();
    getAllDevices();
  }

  Future<void> deleteDevice(DevicesTableData device) async {
    _invalidDeviceId.add(device.id);

    // Delete related data from other tables first
    await (_database!.delete(_database!.colectedDataTable)
          ..where((tbl) => tbl.deviceId.equals(device.id)))
        .go();
    getLatestCollectedData();

    await (_database!.delete(_database!.deviceWifiTable)
          ..where((tbl) => tbl.deviceId.equals(device.id)))
        .go();
    getAllDeviceWifi();

    await (_database!.delete(_database!.deviceParameterTable)
          ..where((tbl) => tbl.deviceId.equals(device.id)))
        .go();
    getAllDeviceParameters();

    await (_database!.delete(_database!.deviceAlarmsTable)
          ..where((tbl) => tbl.deviceId.equals(device.id)))
        .go();
    getAllDeviceAlarms();

    await _database!.delete(_database!.devicesTable).delete(device);
    notifyListeners();
    getAllDevices();
  }

  // ParametersTable
  Future<void> upsertParameter(ParametersTableCompanion parameter) async {
    await _database!
        .into(_database!.parametersTable)
        .insertOnConflictUpdate(parameter);
    notifyListeners();
    await getAllParameters();
  }

  Future<void> insertParameter(ParametersTableCompanion parameter) async {
    await _database!
        .into(_database!.parametersTable)
        .insert(parameter, mode: InsertMode.insertOrIgnore);
    notifyListeners();
    await getAllParameters();
  }

  Future<void> getAllParameters() async {
    _parameters = await _database!.select(_database!.parametersTable).get();
    notifyListeners();
  }

  Future<ParametersTableData?> getParameterById(int id) async {
    var parameter = await (_database!.select(_database!.parametersTable)
          ..where((tbl) => tbl.index.equals(id)))
        .getSingle();
    return parameter;
  }

  Future<void> updateParameter(ParametersTableData parameter) async {
    parametersChanged = true;
    await _database!.update(_database!.parametersTable).replace(parameter);
    notifyListeners();
    await getAllParameters();
  }

  // ColectedDataTable
  Future<void> insertCollectedData(ColectedDataTableCompanion data) async {
    if (_invalidDeviceId.contains(data.deviceId.value) == false) {
      await _database!.into(_database!.colectedDataTable).insert(data);
      notifyListeners();
      getLatestCollectedData();
    }
  }

  Future<void> getLatestCollectedData() async {
    final query = await database!.select(_database!.colectedDataTable)
      ..limit(_devices != null ? _devices!.length * 10 : 10);
    query.orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
    ]);
    _collectedData = await query.get();
    notifyListeners();
  }

  Future<void> getAllCollectedData() async {
    _collectedData =
        await _database!.select(_database!.colectedDataTable).get();
    notifyListeners();
  }

  Future<void> updateCollectedData(ColectedDataTableData data) async {
    await _database!.update(_database!.colectedDataTable).replace(data);
    notifyListeners();
  }

  // DeviceWifiTable
  Future<void> insertDeviceWifi(DeviceWifiTableData deviceWifi) async {
    await _database!.into(_database!.deviceWifiTable).insert(deviceWifi);
    notifyListeners();
  }

  Future<void> getAllDeviceWifi() async {
    _deviceWifi = await _database!.select(_database!.deviceWifiTable).get();
    notifyListeners();
  }

  Future<void> updateDeviceWifi(DeviceWifiTableData deviceWifi) async {
    await _database!.update(_database!.deviceWifiTable).replace(deviceWifi);
    notifyListeners();
  }

  // WifiTable
  Future<void> insertWifi(WifiTableCompanion wifi) async {
    await _database!.into(_database!.wifiTable).insert(wifi);
    notifyListeners();
    await getAllWifi();
  }

  Future<void> getAllWifi() async {
    _wifi = await _database!.select(_database!.wifiTable).get();
    notifyListeners();
  }

  Future<void> updateWifi(WifiTableData wifi) async {
    await _database!.update(_database!.wifiTable).replace(wifi);
    notifyListeners();
    await getAllWifi();
  }

  Future<void> deleteWifi(WifiTableData wifi) async {
    await _database!.delete(_database!.wifiTable).delete(wifi);
    notifyListeners();
    await getAllWifi();
  }

  // MqttTable
  Future<void> insertMqtt(MqttTableCompanion mqtt) async {
    await _database!.into(_database!.mqttTable).insert(mqtt);
    notifyListeners();
    await getAllMqtt();
  }

  Future<void> getAllMqtt() async {
    _mqtt = await _database!.select(_database!.mqttTable).get();
    notifyListeners();
  }

  Future<void> updateMqtt(MqttTableData mqtt) async {
    await _database!.update(_database!.mqttTable).replace(mqtt);
    notifyListeners();
    await getAllMqtt();
  }

  Future<void> deleteMqtt(MqttTableData mqtt) async {
    await _database!.delete(_database!.mqttTable).delete(mqtt);
    notifyListeners();
    await getAllMqtt();
  }

  // MqttParameterTable
  Future<void> insertMqttParameter(
      MqttParameterTableCompanion parameter) async {
    await _database!.into(_database!.mqttParameterTable).insert(parameter);
    notifyListeners();
    getAllMqttParameters();
  }

  Future<void> getAllMqttParameters() async {
    _mqttParameters =
        await _database!.select(_database!.mqttParameterTable).get();
    notifyListeners();
  }

  Future<void> updateMqttParameter(MqttParameterTableData parameter) async {
    await _database!.update(_database!.mqttParameterTable).replace(parameter);
    notifyListeners();
  }

  // DeviceParameterTable
  Future<void> insertDeviceParameter(
      DeviceParameterTableCompanion parameter) async {
    processDeviceSettingChanges.addOrUpdate(parameter.deviceId.value);
    await _database!.into(_database!.deviceParameterTable).insert(parameter);
    notifyListeners();
    getAllDeviceParameters();
  }

  Future<void> getAllDeviceParameters() async {
    _deviceParameters =
        await _database!.select(_database!.deviceParameterTable).get();
    notifyListeners();
  }

  Future<void> updateDeviceParameter(DeviceParameterTableData parameter) async {
    processDeviceSettingChanges.addOrUpdate(parameter.deviceId);
    await _database!.update(_database!.deviceParameterTable).replace(parameter);
    notifyListeners();
    getAllDeviceParameters();
  }

  // AlarmsTable
  Future<AlarmsTableData?> insertAlarm(AlarmsTableCompanion alarm) async {
    final id = await _database!.into(_database!.alarmsTable).insert(alarm);
    notifyListeners();
    getAllAlarms();

    final insertedAlarm = await (_database!.select(_database!.alarmsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    return insertedAlarm;
  }

  Future<void> getAllAlarms() async {
    _alarms = await _database!.select(_database!.alarmsTable).get();
    notifyListeners();
  }

  Future<void> updateAlarm(AlarmsTableData alarm) async {
    alarmsChanged = true;
    await _database!.update(_database!.alarmsTable).replace(alarm);
    notifyListeners();
    await getAllAlarms();
  }

  Future<void> deleteAlarm(AlarmsTableData alarm) async {
    await _database!.delete(_database!.alarmsTable).delete(alarm);
    notifyListeners();
    await getAllAlarms();
  }

  // DeviceAlarmsTable
  Future<void> insertDeviceAlarm(DeviceAlarmsTableCompanion deviceAlarm) async {
    processDeviceSettingChanges.addOrUpdate(deviceAlarm.deviceId.value);
    await _database!.into(_database!.deviceAlarmsTable).insert(deviceAlarm);
    notifyListeners();
    getAllDeviceAlarms();
  }

  Future<void> getAllDeviceAlarms() async {
    _deviceAlarms = await _database!.select(_database!.deviceAlarmsTable).get();
    notifyListeners();
  }

  Future<void> updateDeviceAlarm(DeviceAlarmsTableData deviceAlarm) async {
    await _database!.update(_database!.deviceAlarmsTable).replace(deviceAlarm);
    notifyListeners();
  }

  Future<void> deleteDeviceAlarm(DeviceAlarmsTableData deviceAlarm) async {
    processDeviceSettingChanges.addOrUpdate(deviceAlarm.deviceId);
    await _database!.delete(_database!.deviceAlarmsTable).delete(deviceAlarm);
    notifyListeners();
    getAllDeviceAlarms();
  }

  // AlarmsParameterTable
  Future<void> insertAlarmParameter(
      AlarmsParameterTableCompanion parameter) async {
    alarmsChanged = true;
    await _database!.into(_database!.alarmsParameterTable).insert(parameter);
    notifyListeners();
    await getAllAlarmParameters(parameter.alarmId.value);
  }

  Future<void> getAllAlarmParameters(int alarmId) async {
    // Await the result of the query
    _alarmParameters = await (_database!.select(_database!.alarmsParameterTable)
          ..where((tbl) => tbl.alarmId.equals(alarmId)))
        .get();
    notifyListeners();
  }

  Future<void> updateAlarmParameter(AlarmsParameterTableData parameter) async {
    alarmsChanged = true;
    await _database!.update(_database!.alarmsParameterTable).replace(parameter);
    notifyListeners();
    await getAllAlarmParameters(parameter.alarmId);
  }

  Future<void> deleteAlarmParameter(AlarmsParameterTableData parameter) async {
    await _database!.delete(_database!.alarmsParameterTable).delete(parameter);
    notifyListeners();
    await getAllAlarmParameters(parameter.alarmId);
  }
}
