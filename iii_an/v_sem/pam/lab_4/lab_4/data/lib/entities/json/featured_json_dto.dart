import 'package:json_annotation/json_annotation.dart';

part 'featured_json_dto.g.dart';

@JsonSerializable()
class FeaturedJsonDto{
  final String cover;
  final String title;

  FeaturedJsonDto(this.cover, this.title);
  factory FeaturedJsonDto.fromJson(Map<String, dynamic> json) => _$FeaturedJsonDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FeaturedJsonDtoToJson(this);
}
