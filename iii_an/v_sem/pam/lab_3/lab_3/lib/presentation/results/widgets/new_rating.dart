
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/results/result_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class NewRating extends StatelessWidget{
  const NewRating({super.key});

  Widget build(BuildContext context) {
    ResultController controller = Get.find();
    return Container(
      margin: EdgeInsets.only(top: 24),
      height: 70,
      width: 78,
      child: Column(
        children: [
          Text("New Rating",
              style: TextStyles.textStyleSfProText14(
                  color: CustomColors.gray,fontWeight: FontWeight.w500,height: 1.57
              )
          ),
          SizedBox(
            height: 8,
          ),
          Obx(() =>
              Text(
                  "${controller.newRating}",
                  style: TextStyles.textStyleSfProText32(
                      color: Colors.black,fontWeight: FontWeight.w600,height: 1.25)
              ),
          ),
        ],
      ),
    );
  }
}