// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      json['title'] as String,
      (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
      json['correct'] as int,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'title': instance.title,
      'answers': instance.answers,
      'correct': instance.correct,
    };
