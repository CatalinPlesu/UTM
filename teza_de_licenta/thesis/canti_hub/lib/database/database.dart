import 'dart:io';
import 'package:canti_hub/common/app_settings.dart';
import 'package:canti_hub/common/files.dart';
import 'package:canti_hub/database/tables.dart';
import 'package:canti_hub/database/custom_types.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, Files.database));

    return NativeDatabase(file, logStatements: AppSettings.dbLogging);
  });
}

@DriftDatabase(tables: [
  DevicesTable,
  ParametersTable,
  ColectedDataTable,
  DeviceWifiTable,
  WifiTable,
  MqttTable,
  DeviceMqttTable,
  DeviceParameterTable,
  MqttParameterTable,
  AlarmsTable,
  DeviceAlarmsTable,
  AlarmsParameterTable
])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;


  Future<List<TypedResult>> getLatestCollectedData() async {
    final query = selectOnly(deviceParameterTable)
      ..addColumns([
       colectedDataTable.deviceId,
        colectedDataTable.parameterId,
           colectedDataTable.createdAt,
            colectedDataTable.value,
      ]);
    query
      ..groupBy([colectedDataTable.parameterId])
      ..orderBy([
       OrderingTerm.desc(colectedDataTable.createdAt)
      ]);
  return await query.get();
  }
} 
