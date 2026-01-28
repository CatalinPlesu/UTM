// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articles_response_api_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlesResponseApiDto _$ArticlesResponseApiDtoFromJson(
        Map<String, dynamic> json) =>
    ArticlesResponseApiDto(
      (json['results'] as List<dynamic>)
          .map((e) => ArticleApiDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticlesResponseApiDtoToJson(
        ArticlesResponseApiDto instance) =>
    <String, dynamic>{
      'results': instance.articles,
    };
