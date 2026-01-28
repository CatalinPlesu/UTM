import 'package:data/entities/api/author_api_dto.dart';
import 'package:data/entities/api/category_api_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'article_api_dto.g.dart';

@JsonSerializable()
class ArticleApiDto{
  int id;
  AuthorApiDto author;
  CategoryApiDto category;
  List<String> tags;
  String description;
  String content;
  String image;
  int views_count;
  bool is_featured;

  ArticleApiDto(this.id, this.author, this.category, this.tags, this.description, this.content, this.image, this.views_count, this.is_featured);
  factory ArticleApiDto.fromJson(Map<String, dynamic> json) => _$ArticleApiDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleApiDtoToJson(this);
}
