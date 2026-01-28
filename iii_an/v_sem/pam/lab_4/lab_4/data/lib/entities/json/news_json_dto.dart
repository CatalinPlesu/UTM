import 'package:data/entities/json/article_json_dto.dart';
import 'package:data/entities/json/featured_json_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'news_json_dto.g.dart';

@JsonSerializable()
class NewsJsonDto {
  final List<FeaturedJsonDto> featured;
  final List<ArticleJsonDto> news;

  NewsJsonDto (this.featured, this.news);
  factory NewsJsonDto.fromJson(Map<String, dynamic> json) => _$NewsJsonDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NewsJsonDtoToJson(this);
}