// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_json_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsJsonDto _$NewsJsonDtoFromJson(Map<String, dynamic> json) => NewsJsonDto(
      (json['featured'] as List<dynamic>)
          .map((e) => FeaturedJsonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['news'] as List<dynamic>)
          .map((e) => ArticleJsonDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsJsonDtoToJson(NewsJsonDto instance) =>
    <String, dynamic>{
      'featured': instance.featured,
      'news': instance.news,
    };
