import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/question/models/question.dart';
import 'package:math_your_brain/presentation/question/models/questions.dart';
import 'package:math_your_brain/presentation/question/question_page.dart';
import 'package:math_your_brain/resources/files.dart';

class HomeController extends GetxController{

  Rx<DateTime> startTime = DateTime(-1).obs;
  RxBool started = false.obs;
  RxList<Question> questions = RxList();

  void startQuiz() {
    startTime.value = DateTime.now();
    started = true.obs;
    Get.to(QuestionPage());
  }

  void readJsonFile() async {
    String jsonString = await rootBundle.loadString(Files.jsonQuizPath);

    var mapQuestions = json.decode(jsonString);
    Questions response = Questions.fromJson(mapQuestions);
    questions.value = response.questions;
  }

}