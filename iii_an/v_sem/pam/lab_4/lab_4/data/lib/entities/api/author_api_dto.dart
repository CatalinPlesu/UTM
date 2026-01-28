import 'package:json_annotation/json_annotation.dart';
part 'author_api_dto.g.dart';

@JsonSerializable()
class AuthorApiDto{
  int id;
  String modified_at;
  String created_at;
  String name;
  String avatar;

  AuthorApiDto(this.id, this.modified_at, this.created_at, this.name, this.avatar);
  factory AuthorApiDto.fromJson(Map<String, dynamic> json) => _$AuthorApiDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorApiDtoToJson(this);
}
