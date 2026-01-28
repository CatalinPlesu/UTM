import 'package:domain/models/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticlesApi(int page, int per_page);

  Future<List<Article>> getArticlesFromDb();

  Future<void> insertArticlesDb(List<Article> articles);

  Stream<List<Article>> getArticlesStream();

  Future<List<Article>> getArticles();
}
