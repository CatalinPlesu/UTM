import 'package:data/datasources/json/news_json_data_source.dart';
import 'package:data/mappers/FeaturedMapper.dart';
import 'package:data/mappers/NewsMapper.dart';
import 'package:domain/models/featured.dart';
import 'package:domain/models/news.dart';
import 'package:domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsJsonDataSource newsJsonDataSource;

  NewsRepositoryImpl(this.newsJsonDataSource);


  @override
  Future<List<News>> getNewsJson(String filePath) async{
    var news = await newsJsonDataSource.getNews(filePath);
    return news.map((e) => NewsMapper().mapJsonDtoToModel(e)).toList();
  }

  @override
  Future<List<Featured>> getFeaturedJson(String filePath) async {
    var featured = await newsJsonDataSource.getFeatured(filePath);
    return featured.map((e) => FeaturedMapper().mapJsonDtoToModel(e)).toList();
  }
}