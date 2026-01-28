import 'dart:convert';
import 'package:data/entities/json/article_json_dto.dart';
import 'package:data/entities/json/featured_json_dto.dart';
import 'package:flutter/services.dart';
import 'package:data/entities/json/news_json_dto.dart';

abstract class NewsJsonDataSource{
  Future<List<ArticleJsonDto>> getNews(String filePath);
  Future<List<FeaturedJsonDto>> getFeatured(String filePath);
}

class NewsJsonDataSourceImpl implements NewsJsonDataSource {

  @override
  Future<List<ArticleJsonDto>> getNews(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);

    var mapQuestions = json.decode(jsonString);
    NewsJsonDto response = NewsJsonDto.fromJson(mapQuestions);
    return response.news;
  }

  Future<List<FeaturedJsonDto>> getFeatured(String filePath) async{
    String jsonString = await rootBundle.loadString(filePath);

    var mapQuestions = json.decode(jsonString);
    NewsJsonDto response = NewsJsonDto.fromJson(mapQuestions);
    return response.featured;
  }
}