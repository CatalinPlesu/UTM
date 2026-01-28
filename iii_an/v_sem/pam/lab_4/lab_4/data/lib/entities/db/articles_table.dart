import 'package:drift/drift.dart';

class ArticlesTable extends Table{
  IntColumn get id => integer()();

  IntColumn get author_id => integer()();
  TextColumn get author_modified_at => text()();
  TextColumn get author_created_at => text()();
  TextColumn get author_name => text()();
  TextColumn get author_avatar => text()();

  IntColumn get category_id => integer()();
  TextColumn get category_modified_at => text()();
  TextColumn get category_created_at => text()();
  TextColumn get category_title => text()();

  TextColumn get tags => text()();
  TextColumn get description => text()();
  TextColumn get content => text()();
  TextColumn get image => text()();
  IntColumn get views_count => integer()();
  BoolColumn get is_featured => boolean()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}