import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/question/question_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class Button extends StatelessWidget{
  Button({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.find();
    return Container(
        width: 999,
        height: 46,
        margin: EdgeInsets.all(24),
        child:TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                )
            ),
            backgroundColor: MaterialStatePropertyAll<Color>(CustomColors.shark),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed:() {
            questionController.NextButton();
          },
          child: Text(
              "Next",
              style: TextStyles.textStyleSfProText14(
                  color: CustomColors.white,fontWeight: FontWeight.w500,height: 1.57) ),
        )
    );
  }

}