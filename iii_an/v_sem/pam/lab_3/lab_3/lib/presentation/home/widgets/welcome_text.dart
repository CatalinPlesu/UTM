import 'package:flutter/cupertino.dart';
import 'package:math_your_brain/resources/custom_colors.dart';
import 'package:math_your_brain/resources/strings.dart';
import 'package:math_your_brain/resources/text_styles.dart';

class WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: const EdgeInsets.only(top: 44.0),
      child: Text(
          Strings.welcome,
          textAlign: TextAlign.center,
          style: TextStyles.textStyleSfProText48(
            color: CustomColors.shark,
            fontWeight: FontWeight.w600,
            height: 1.16,
          )
      ),
    );
  }
}