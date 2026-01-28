import 'package:data/entities/json/portal_json_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'article_json_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ArticleJsonDto{
  final String cover;
  final String title;
  final String category;
  final PortalJsonDto portal;
  final int likes;
  final int comments;

  ArticleJsonDto(this.cover, this.title, this.category, this.portal, this.likes, this.comments);
  factory ArticleJsonDto.fromJson(Map<String, dynamic> json) => _$ArticleJsonDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleJsonDtoToJson(this);
}
