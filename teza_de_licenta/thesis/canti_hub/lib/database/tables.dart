import 'package:canti_hub/database/custom_types.dart';
import 'package:drift/drift.dart';

class DevicesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<DeviceType>()();
  TextColumn get remoteId => text()();
  TextColumn get name => text()();
  TextColumn get displayNmae => text()();
  TextColumn get softwareVersion => text()();
  TextColumn get hardwareVersion => text()();
  DateTimeColumn get firstConnection => dateTime()();
  DateTimeColumn get lastOnline => dateTime()();
  DateTimeColumn get time => dateTime().nullable()();
}

class ParametersTable extends Table {
  IntColumn get index => integer()();
  TextColumn get name => text()();
  IntColumn get recurrence => integer()();
  RealColumn get normal => real()();
  RealColumn get max => real()();
  RealColumn get min => real()();
  TextColumn get units => text()();

  @override
  Set<Column<Object>>? get primaryKey => {index};
}

class ColectedDataTable extends Table {
  IntColumn get parameterId => integer().references(ParametersTable, #index)();
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get value => real()();

  @override
  Set<Column<Object>>? get primaryKey => {parameterId, deviceId, createdAt};
}

class DeviceWifiTable extends Table {
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get wifiId => integer().references(WifiTable, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {deviceId, wifiId};
}

class WifiTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ssid => text()();
  TextColumn get password => text()();
}

class MqttTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverUrl => text()();
  IntColumn get port =>
      integer().nullable().withDefault(const Constant(1883))();
  TextColumn get apiKey => text().nullable()();
  TextColumn get username => text()();
  TextColumn get password => text().nullable()();
}

class DeviceMqttTable extends Table {
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get mqttId => integer().references(MqttTable, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {deviceId, mqttId};
}

class DeviceParameterTable extends Table {
  IntColumn get parameterId => integer().references(ParametersTable, #index)();
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  BoolColumn get useUserConfig =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {parameterId, deviceId};
}

class MqttParameterTable extends Table {
  IntColumn get parameterId => integer().references(ParametersTable, #index)();
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get mqttId => integer().references(MqttTable, #id)();
  TextColumn get topic => text()();

  @override
  Set<Column<Object>>? get primaryKey => {parameterId, deviceId, mqttId};
}

class AlarmsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get activated => boolean()();
}

class DeviceAlarmsTable extends Table {
  IntColumn get deviceId => integer().references(DevicesTable, #id)();
  IntColumn get alarmId => integer().references(AlarmsTable, #id)();
  IntColumn get slot => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {deviceId, alarmId, slot};
}

class AlarmsParameterTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get alarmId => integer().references(AlarmsTable, #id)();
  IntColumn get parameterId => integer().references(ParametersTable, #index)();
  RealColumn get lowerValue => real().nullable()();
  RealColumn get upperValue => real().nullable()();
  IntColumn get triggerType => intEnum<TriggerType>()();
}
