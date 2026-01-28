import 'package:data/database/database.dart';
import 'package:data/datasources/api/news_api_data_source.dart';
import 'package:data/datasources/db/articles_db_data_source.dart';
import 'package:data/datasources/json/news_json_data_source.dart';
import 'package:data/repositories/article_repository_impl.dart';
import 'package:data/repositories/news_repository_impl.dart';
import 'package:domain/repositories/article_repository.dart';
import 'package:domain/repositories/news_repository.dart';
import 'package:get_it/get_it.dart';

Future initData() async {
  var getIt = GetIt.instance;

  //instanta de LocalDataBase
  getIt.registerLazySingleton(() => Database());

  //DataSources
  getIt.registerLazySingleton<NewsJsonDataSource>(() => NewsJsonDataSourceImpl());
  getIt.registerLazySingleton<NewsApiDataSource>(() => NewsApiDataSourceImpl());
  getIt.registerLazySingleton<ArticlesDbDataSource>(() => ArticlesDbDataSourceImpl(getIt.get<Database>()));

  //Repositorii
  getIt.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(getIt.get<NewsJsonDataSource>()));
  getIt.registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(getIt.get<NewsApiDataSource>(),
          getIt.get<ArticlesDbDataSource>()));
}