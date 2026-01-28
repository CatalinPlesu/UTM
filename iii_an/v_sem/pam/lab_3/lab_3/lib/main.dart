import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_your_brain/presentation/home/home_page.dart';
import 'package:math_your_brain/presentation/question/question_page.dart';
import 'package:math_your_brain/presentation/results/result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Math Your Brain',
      theme: ThemeData(),
      home: const HomePage(),
      // home: const QuestionPage(),
      // home: const ResultPage(),
    );
  }
}