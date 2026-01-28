import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/question/question_controller.dart';
import 'package:math_your_brain/resources/app_settings.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/svg_assets.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class Countdown extends StatefulWidget{
  Countdown({super.key});

  @override
  State<StatefulWidget> createState() => _Countdown();
}

class _Countdown extends State<Countdown>{

  @override
  Widget build(BuildContext context) {
    QuestionController controller = Get.find();
    return Obx(() =>
        Container(
          margin: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      //color: Colors.amber,
                      margin: EdgeInsets.only(left:2.0,top:5.0,right: 6.0,bottom: 5.0),
                      child: SvgAssets.clockPicture,
                    ),
                    Container(
                      //color: Colors.blue.shade50,
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      //padding: ,
                      width: 26,
                      height: 22,
                      child: Text(
                        "${controller.remainingSeconds.value}s",
                        style: TextStyles.textStyleSfProText14(
                          color: CustomColors.boulder,fontWeight: FontWeight.w500,/*height: 22/14*/),
                      ),

                    )
                  ],
                ),
              ),
              Container(
                height: 6.0,
                width: 342,
                margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
                decoration: BoxDecoration(
                  color: CustomColors.antiFlashWhite,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                clipBehavior: Clip.antiAlias,
                child:
                // TweenAnimationBuilder(
                //   duration: Duration(seconds: AppSettings.questionTime),
                //   tween: Tween<double>(begin:controller.tween_begin.value, end:controller.tween_end.value),
                //   builder: (context, value, widget){
                //    return FractionallySizedBox(
                //      alignment: Alignment.centerLeft,
                //      widthFactor: value,
                //      heightFactor: 1.0,
                //      child: Container(
                //        decoration: BoxDecoration(
                //          color: CustomColors.green,
                //          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                //        ),
                //        clipBehavior: Clip.antiAlias,
                //      ),
                //    );
                //   },
                //
                // ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (controller.remainingSeconds.value / AppSettings.questionTime as double) ,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CustomColors.green,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    clipBehavior: Clip.antiAlias,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}