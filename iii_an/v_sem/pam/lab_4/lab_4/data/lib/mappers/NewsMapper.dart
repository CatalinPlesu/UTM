import 'package:data/entities/json/article_json_dto.dart';
import 'package:data/mappers/PortalMapper.dart';
import 'package:domain/models/news.dart';

class NewsMapper {

  News mapJsonDtoToModel(ArticleJsonDto article){
    return News(article.cover, article.title, article.category, PortalMapper().mapJsonDtoToModel(article.portal), article.likes, article.comments);
  }
}