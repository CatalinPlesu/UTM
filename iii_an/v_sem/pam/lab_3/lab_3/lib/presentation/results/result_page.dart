import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/results/result_controller.dart';
import 'package:math_your_brain/presentation/results/widgets/new_rating.dart';
import 'package:math_your_brain/presentation/results/widgets/score.dart';
import 'package:math_your_brain/presentation/results/widgets/button.dart';
import 'package:math_your_brain/resources/custom_colors.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _MyResultPageState();
}

class _MyResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ResultController());
    ResultController controller = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    ResultController controller = Get.find();
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Center(
        child: Container(
          width: double.infinity,
          height: 318,
          margin: const EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              border: Border.all(
                  color: CustomColors.antiFlashWhite,
                  width: 2
              ),
              borderRadius: BorderRadius.circular(16.0)
          ),
          child: Column(
            children: [
              const NewRating(),
              Score(),
              Button(text: "Leave", onPressed: (){
                controller.leave();
              },
                  backgrounColor: CustomColors.antiFlashWhite,
                  textColor: Colors.black,
              ),
              Button(
                text: "New Game",
                onPressed: () {
                  controller.newGame();
                },
                backgrounColor: CustomColors.shark,
                textColor: Colors.white,
              ),
              // const NewGame();
            ],
          ),
        ),
      ),
    );
  }
}
