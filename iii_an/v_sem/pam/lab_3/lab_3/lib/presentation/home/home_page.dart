import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/widgets/start_button.dart';
import 'package:math_your_brain/presentation/home/widgets/welcome_text.dart';
import 'package:math_your_brain/presentation/question/question_controller.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/strings.dart';
import 'package:math_your_brain/resources/text_styles.dart';
import 'home_controller.dart';
import 'widgets/image_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if(!Get.isRegistered<HomeController>()){
      Get.lazyPut(() => HomeController ());
    }
    HomeController controller = Get.find();
    controller.readJsonFile();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
            children: [
              ImageWidget(),
              WelcomeText(),
              StartButton(),
  ]
        )
    );
  }
}
