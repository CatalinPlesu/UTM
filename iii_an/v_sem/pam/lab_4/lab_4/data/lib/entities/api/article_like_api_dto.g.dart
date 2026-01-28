// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_like_api_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleLikeApiDto _$ArticleLikeApiDtoFromJson(Map<String, dynamic> json) =>
    ArticleLikeApiDto(
      json['id'] as int,
      json['modified_at'] as String,
      json['created_at'] as String,
      json['article'] as int,
    );

Map<String, dynamic> _$ArticleLikeApiDtoToJson(ArticleLikeApiDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'modified_at': instance.modified_at,
      'created_at': instance.created_at,
      'article': instance.article,
    };
