import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/home_controller.dart';
import 'package:math_your_brain/presentation/question/question_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class Question extends StatelessWidget{
  Question({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.find();
    HomeController homeController = Get.find();

    return Container(
      margin: EdgeInsets.only(top: 80,bottom: 24, left: 24, right: 24),
      height: 118,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 22,
            width: double.infinity,
            //color: Colors.indigo,
            child: Obx(() =>
                Text( questionController.remainingQuestions(),
                  style: TextStyles.textStyleSfProText14(
                      color: CustomColors.boulder,
                      fontWeight: FontWeight.w500,
                      height: 1.57
                  ),
                ),
            ),
          ),
          Container(
            height: 88,
            width: double.infinity,
            //color: Colors.brown,
            child: Obx(
                () =>
                    Text(homeController.questions[questionController.currentQuestion.value].title,
                      style: TextStyles.textStyleSfProText14(
                          color: CustomColors.shark,
                          fontWeight: FontWeight.w500,
                          height: 1.57
                      ),
                      textAlign: TextAlign.justify,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}