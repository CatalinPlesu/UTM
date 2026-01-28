import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/home_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/strings.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class StartButton extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find();
    return      Container(
        width: 280,
        height: 46,
        margin: EdgeInsets.only(top: 32.0),
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
            controller.startQuiz();
          }, child: Text(
    Strings.start,
    style: TextStyles.textStyleSfProText14(
    color: CustomColors.white,fontWeight: FontWeight.w500,height: 1.57)
    ),  ),
    );
  }
}