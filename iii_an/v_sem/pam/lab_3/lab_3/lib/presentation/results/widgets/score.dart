
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/results/result_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class Score extends StatelessWidget{
  Score({super.key});

  @override
  Widget build(BuildContext context) {
  ResultController controller = Get.find();
    return Obx(() =>
        Container(
          margin: EdgeInsets.only(top: 20),
          width: 294,
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 78,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Score",
                        style: TextStyles.textStyleSfProText12(
                            color: CustomColors.gray,fontWeight: FontWeight.w500,height: 1.66
                        )
                    ),
                    Text(controller.getScore(),
                        style: TextStyles.textStyleSfProText18(
                            color: Colors.black,fontWeight: FontWeight.w600,height: 1.33
                        )
                    )
                  ],
                ),
              ),
              Container(
                width: 78,
                //color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Correct",
                        style: TextStyles.textStyleSfProText12(
                            color: CustomColors.gray,fontWeight: FontWeight.w500,height: 1.66
                        )
                    ),
                    Text(controller.getCorrect(),
                        style: TextStyles.textStyleSfProText18(
                            color: Colors.black,fontWeight: FontWeight.w600,height: 1.33
                        )
                    )
                  ],
                ),
              ),
              Container(
                width: 78,
                //margin: EdgeInsets.only(right: 10),
                //color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Completed in",
                        style: TextStyles.textStyleSfProText12(
                            color: CustomColors.gray,fontWeight: FontWeight.w500,height: 1.66
                        )
                    ),
                    Text(controller.getTime(),
                        style: TextStyles.textStyleSfProText18(
                            color: Colors.black,fontWeight: FontWeight.w600,height: 1.33
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}