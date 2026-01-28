import 'package:domain/models/featured.dart';
import 'package:domain/models/news.dart';

abstract class NewsRepository {
  Future<List<News>> getNewsJson(String filePath);

  Future<List<Featured>> getFeaturedJson(String filePath);
}