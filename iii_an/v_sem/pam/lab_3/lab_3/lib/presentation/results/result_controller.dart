
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/home_controller.dart';
import 'package:math_your_brain/presentation/home/home_page.dart';
import 'package:math_your_brain/presentation/question/models/question.dart';
import 'package:math_your_brain/presentation/question/question_controller.dart';
import 'package:math_your_brain/resources/app_settings.dart';

class ResultController extends GetxController{
  HomeController homeController = Get.find();
  QuestionController questoinController = Get.find();
  RxInt newRating = 425.obs;
  RxInt score = 0.obs;
  RxInt correct = 0.obs;

  @override
  void onInit() {
    score.value = questoinController.correct.value * AppSettings.questionScore;
    correct = questoinController.correct;
    super.onInit();
  }

  String getRating(){
    return "${newRating.value}";
  }

  String getScore(){
    return "${score.value}/${homeController.questions.length * AppSettings.questionScore}";
  }

  String getTime(){
    final Duration elapsed = DateTime.now().difference(homeController.startTime.value);
    return "${elapsed.inMinutes}m ${elapsed.inSeconds}s";
  }

  String getCorrect(){
    return "${questoinController.correct}/${questoinController.totalQuestions}";
  }

  void newGame(){
    Get.offAll(HomePage());
  }

  void leave(){
    SystemNavigator.pop();
  }
}