// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_api_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorApiDto _$AuthorApiDtoFromJson(Map<String, dynamic> json) => AuthorApiDto(
      json['id'] as int,
      json['modified_at'] as String,
      json['created_at'] as String,
      json['name'] as String,
      json['avatar'] as String,
    );

Map<String, dynamic> _$AuthorApiDtoToJson(AuthorApiDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'modified_at': instance.modified_at,
      'created_at': instance.created_at,
      'name': instance.name,
      'avatar': instance.avatar,
    };
