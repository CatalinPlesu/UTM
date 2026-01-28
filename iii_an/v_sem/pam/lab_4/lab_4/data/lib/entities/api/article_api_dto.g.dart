// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_api_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleApiDto _$ArticleApiDtoFromJson(Map<String, dynamic> json) =>
    ArticleApiDto(
      json['id'] as int,
      AuthorApiDto.fromJson(json['author'] as Map<String, dynamic>),
      CategoryApiDto.fromJson(json['category'] as Map<String, dynamic>),
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      json['description'] as String,
      json['content'] as String,
      json['image'] as String,
      json['views_count'] as int,
      json['is_featured'] as bool,
    );

Map<String, dynamic> _$ArticleApiDtoToJson(ArticleApiDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'category': instance.category,
      'tags': instance.tags,
      'description': instance.description,
      'content': instance.content,
      'image': instance.image,
      'views_count': instance.views_count,
      'is_featured': instance.is_featured,
    };
