import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/question/models/question.dart';
import 'package:math_your_brain/presentation/question/question_controller.dart';
import 'package:math_your_brain/presentation/question/widgets/answer.dart';
import 'package:math_your_brain/presentation/question/widgets/button.dart';
import 'package:math_your_brain/presentation/question/widgets/countdown.dart';
import 'package:math_your_brain/presentation/question/widgets/question.dart' as questionWidget;
import 'package:math_your_brain/resources/custom_colors.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _MyQuestionPageState();
}

class _MyQuestionPageState extends State<QuestionPage> {
  @override
  void initState() {
    if(!Get.isRegistered<QuestionController>()){
      Get.lazyPut(() => QuestionController());
    }
    QuestionController controller = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.white,
        body: Center(
            child: Column(
      children: [
        Countdown(),
        questionWidget.Question(),
        Answer(index: 0),
        Answer(index: 1),
        Answer(index: 2),
        Answer(index: 3),
        Button(),
      ],
    )));
  }
}
