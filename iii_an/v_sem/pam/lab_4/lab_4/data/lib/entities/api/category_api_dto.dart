import 'package:json_annotation/json_annotation.dart';
part 'category_api_dto.g.dart';

@JsonSerializable()
class CategoryApiDto{
  int id;
  String modified_at;
  String created_at;
  String title;

  CategoryApiDto(this.id, this.modified_at, this.created_at, this.title);
  factory CategoryApiDto.fromJson(Map<String, dynamic> json) => _$CategoryApiDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryApiDtoToJson(this);
}
