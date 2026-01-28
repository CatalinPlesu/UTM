import 'package:json_annotation/json_annotation.dart';
import 'package:math_your_brain/presentation/question/models/question.dart';

part 'questions.g.dart';

@JsonSerializable()
class Questions {
  final List<Question> questions;

  Questions(this.questions);

  factory Questions.fromJson(Map<String, dynamic> json) => _$QuestionsFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}
