import 'package:data/entities/api/article_api_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'articles_response_api_dto.g.dart';

@JsonSerializable()
class ArticlesResponseApiDto {
  @JsonKey(name: 'results')
  final List<ArticleApiDto> articles;

  ArticlesResponseApiDto(this.articles);

  factory ArticlesResponseApiDto.fromJson(Map<String, dynamic> json) => _$ArticlesResponseApiDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlesResponseApiDtoToJson(this);
}