import 'package:json_annotation/json_annotation.dart';
part 'portal_json_dto.g.dart';

@JsonSerializable()
class PortalJsonDto{
  final String title;
  final String logo;

  PortalJsonDto(this.title, this.logo);
  factory PortalJsonDto.fromJson(Map<String, dynamic> json) => _$PortalJsonDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PortalJsonDtoToJson(this);
}

