import 'package:data/datasources/api/news_api_data_source.dart';
import 'package:data/datasources/db/articles_db_data_source.dart';
import 'package:data/mappers/article_mapper.dart';
import 'package:domain/models/article.dart';
import 'package:domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiDataSource newsApiDataSource;
  final ArticlesDbDataSource articlesDbDataSource;

  ArticleRepositoryImpl(this.newsApiDataSource, this.articlesDbDataSource);

  @override
  Future<List<Article>> getArticlesApi(int page, int per_page) async{
    var articles = await newsApiDataSource.getArticles(page, per_page);
    return articles.map((e) => ArticleMapper().mapApiDtoToModel(e)).toList();
  }

  @override
  Future<List<Article>> getArticlesFromDb() async {
    var articles = await articlesDbDataSource.getArticles();
    return articles.map((e) => ArticleMapper().mapDbToModel(e)).toList();
  }

  @override
  Future<void> insertArticlesDb(List<Article> articles) async {
    return articlesDbDataSource.insertArticles(articles.map((e) => ArticleMapper().mapModelToDb(e)).toList());
  }

  @override
  Stream<List<Article>> getArticlesStream() {
    return articlesDbDataSource
        .getArticlesStream()
        .map((articles) => articles.map((e) => ArticleMapper().mapDbToModel(e)).toList());  }

  @override
  Future<List<Article>> getArticles() async {
    var articles = await articlesDbDataSource.getArticles();
    return   articles.map((e) => ArticleMapper().mapDbToModel(e)).toList();
  }

}