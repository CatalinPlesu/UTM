import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/home_page.dart';
import 'package:math_your_brain/presentation/results/result_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class Button extends StatelessWidget {

  final String text;
  final GestureTapCallback onPressed;
  final Color backgrounColor;
  final Color textColor;

  Button({
      super.key,
      required this.text,
      required this.onPressed,
      required this.backgrounColor,
      required this.textColor,
    });

  Widget build(BuildContext context) {
    ResultController controller = Get.find();
    return
          Container(
              width: 294,
              height: 46,
              margin: EdgeInsets.only(top: 16.0),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  )),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(backgrounColor),
                ),
                onPressed: onPressed ?? () {print("null function");},
                child: Text( text,
                    style: TextStyles.textStyleSfProText14(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        height: 1.57)),
              ),);
  }
}