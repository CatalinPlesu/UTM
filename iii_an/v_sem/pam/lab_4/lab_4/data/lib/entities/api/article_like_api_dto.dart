import 'package:json_annotation/json_annotation.dart';
part 'article_like_api_dto.g.dart';

@JsonSerializable()
class ArticleLikeApiDto{
  int id;
  String modified_at;
  String created_at;
  int article;

  ArticleLikeApiDto(this.id, this.modified_at, this.created_at, this.article);
  factory ArticleLikeApiDto.fromJson(Map<String, dynamic> json) => _$ArticleLikeApiDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleLikeApiDtoToJson(this);
}
