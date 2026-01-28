// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_json_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleJsonDto _$ArticleJsonDtoFromJson(Map<String, dynamic> json) =>
    ArticleJsonDto(
      json['cover'] as String,
      json['title'] as String,
      json['category'] as String,
      PortalJsonDto.fromJson(json['portal'] as Map<String, dynamic>),
      json['likes'] as int,
      json['comments'] as int,
    );

Map<String, dynamic> _$ArticleJsonDtoToJson(ArticleJsonDto instance) =>
    <String, dynamic>{
      'cover': instance.cover,
      'title': instance.title,
      'category': instance.category,
      'portal': instance.portal.toJson(),
      'likes': instance.likes,
      'comments': instance.comments,
    };
