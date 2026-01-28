import 'package:data/database/database.dart';
import 'package:data/entities/db/articles_table.dart';
import 'package:drift/drift.dart';
import 'package:data/database/database.dart';

abstract class ArticlesDbDataSource {
  Future<void> insertArticles(List<ArticlesTableData> articles);

  Future<List<ArticlesTableData>> getArticles();

  Stream<List<ArticlesTableData>> getArticlesStream();
}

class ArticlesDbDataSourceImpl implements ArticlesDbDataSource {
  Database db;
  ArticlesDbDataSourceImpl(this.db);

  @override
  Future<void> insertArticles(List<ArticlesTableData> articles) async {
    await db.batch((batch) {
      batch.insertAll(db.articlesTable, articles, mode: InsertMode.insertOrReplace);
    });
  }

  @override
  Future<List<ArticlesTableData>> getArticles() async {
    var query = db.select(db.articlesTable);
    return query.get();
  }

  @override
  Stream<List<ArticlesTableData>> getArticlesStream() {
    var query = db.select(db.articlesTable);
    return query.watch();
  }
}