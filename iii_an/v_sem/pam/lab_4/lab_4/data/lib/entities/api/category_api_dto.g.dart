// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiDto _$CategoryApiDtoFromJson(Map<String, dynamic> json) =>
    CategoryApiDto(
      json['id'] as int,
      json['modified_at'] as String,
      json['created_at'] as String,
      json['title'] as String,
    );

Map<String, dynamic> _$CategoryApiDtoToJson(CategoryApiDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'modified_at': instance.modified_at,
      'created_at': instance.created_at,
      'title': instance.title,
    };
