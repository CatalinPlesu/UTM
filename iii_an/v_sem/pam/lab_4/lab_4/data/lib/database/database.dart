import 'dart:io';

import 'package:data/entities/db/articles_table.dart';
import 'package:drift/drift.dart';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.sqlite'));

    return NativeDatabase(file, logStatements: true);
  });
}

@DriftDatabase(tables: [
  ArticlesTable,
])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 2;
}