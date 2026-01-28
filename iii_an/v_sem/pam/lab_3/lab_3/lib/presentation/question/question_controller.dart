import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/home_controller.dart';
import 'package:math_your_brain/presentation/question/question_page.dart';
import 'package:math_your_brain/presentation/results/result_page.dart';
import 'package:math_your_brain/resources/app_settings.dart';
import 'package:math_your_brain/resources/custom_colors.dart';

class QuestionController extends GetxController{
  HomeController homeController = Get.find();
  RxInt totalQuestions = 0.obs;
  RxInt currentQuestion = 0.obs;
  RxInt correct = 0.obs;
  RxInt selected = 0.obs;
  RxInt bar_duration = AppSettings.questionTime.obs;

  RxDouble tween_begin = 1.0.obs;
  RxDouble tween_end = 0.0.obs;

  RxDouble  bar_percentage = 1.0.obs;

  Timer? _timer;
  RxInt remainingSeconds = AppSettings.questionTime.obs;

  @override
  void onInit() {
    totalQuestions = homeController.questions.length.obs;
    super.onInit();
  }

  void NextButton() {


    tween_begin.value = 0.5;
    tween_end.value = 0.5;

    if(_timer!=null){
      _timer!.cancel();
    }
    bar_duration.value = AppSettings.questionTime;
    bar_percentage.value = 1.0;
    if(currentQuestion + 1 == totalQuestions){
      currentQuestion.value = 0;
      Get.offAll(ResultPage());
    } else {
      currentQuestion += 1;
      if(selected.value == homeController.questions[currentQuestion.value].correct){
        correct += 1;
      }
      // Get.offAll(QuestionPage());
      _startTimer(AppSettings.questionTime);
    }
  }

  String remainingQuestions(){
    return "Question ${currentQuestion.value + 1} of ${totalQuestions.value}";
  }

  void selectAnswer(int index){
      selected.value = index;
  }

  Color answerBorderColor(int index){
    return selected.value == index ? CustomColors.dodgerBlue : Colors.white;
  }



  @override
  void onReady(){
    _startTimer(AppSettings.questionTime);
    super.onReady();
  }

  @override
  void onClose(){
    if(_timer!=null){
      _timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds){
    const duration = Duration(seconds: 1);
    remainingSeconds.value = AppSettings.questionTime;
    bar_percentage.value = 0.0;
    _timer = Timer.periodic(duration, (Timer timer) {
      if(remainingSeconds==0){
        bar_percentage.value = 1.0;
        bar_duration.value = 0;
        timer.cancel();
        NextButton();
      }else{
        remainingSeconds -= 1;
      }
    });
  }

}