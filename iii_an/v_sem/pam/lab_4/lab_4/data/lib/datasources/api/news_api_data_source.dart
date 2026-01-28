import 'dart:convert';
import 'package:data/entities/api/article_api_dto.dart';
import 'package:data/entities/api/articles_response_api_dto.dart';
import 'package:http/http.dart' as http;

abstract class NewsApiDataSource {
  Future<List<ArticleApiDto>> getArticles(int page, int per_page);
}

class NewsApiDataSourceImpl implements NewsApiDataSource {
  @override
  Future<List<ArticleApiDto>> getArticles(int page, int per_page) async {
    Uri uri = Uri.parse(
        'https://news-app-api.k8s.devebs.net/articles?per_page=$per_page&page=$page');
    var response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      ArticlesResponseApiDto articlesResponse =
          ArticlesResponseApiDto.fromJson(jsonDecode(response.body));
      return articlesResponse.articles;
    }
    return [];
  }
}
