import 'package:flutter/material.dart';
import 'package:lab_4/resources/custom_collors.dart';
import 'package:lab_4/resources/text_styles.dart';

class Tag extends StatelessWidget {
  final String content;

  Tag({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: CustomColors.bittersweet,
            width: 1.0,
            style: BorderStyle.solid),
      ),
      margin: EdgeInsets.only(left: 15, bottom: 12),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Text(content,
          style: TextStyles.textStyleSourceSansPro14(
              color: CustomColors.bittersweet,
              fontWeight: FontWeight.w600)),
    );
  }
}
