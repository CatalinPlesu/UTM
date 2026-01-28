

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/home_controller.dart';
import 'package:math_your_brain/presentation/question/question_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class Answer extends StatefulWidget{
  final int index;
  const Answer({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => _Answer();
}

class _Answer extends State<Answer>{
  QuestionController questionController = Get.find();
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    int value = 0;
    return Obx(() =>
        Container(
            height: 54,
            margin: const EdgeInsets.fromLTRB(24, 8, 25, 8),
            decoration: BoxDecoration(
                border: Border.all(
                    color: questionController.answerBorderColor(widget.index),
                    width: 2
                ),
                borderRadius: BorderRadius.circular(16.0)
            ),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RadioListTile(
                    dense: true,
                    title: Text(homeController.questions[questionController.currentQuestion.value].answers[widget.index], //widget.txt,
                        style: TextStyles.textStyleSfProText14(
                          color: CustomColors.shark,
                        )
                    ),
                    value: widget.index,
                    groupValue: questionController.selected.value,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged:(ind) {
                      questionController.selectAnswer(widget.index);
                      setState(() {
                        if (ind != null){
                          value = ind;
                        }
                      });
                    }//(current){ changeValue(current);}
                )
              ],
            )
        )
    );
  }
}