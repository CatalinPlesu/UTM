import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_4/resources/custom_collors.dart';
import 'fonts.dart';

class TextStyles {
  static TextStyle textStyleSourceSansPro8(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
          fontSize: 8,
          color: color ?? CustomColors.pickledBluewood,
          fontFamily: Fonts.sourceSansPro,
          fontWeight: fontWeight,
          height: height);

  static TextStyle textStyleSourceSansPro10(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
          fontSize: 10,
          color: color ?? CustomColors.pickledBluewood,
          fontFamily: Fonts.sourceSansPro,
          fontWeight: fontWeight,
          height: height);

  static TextStyle textStyleSourceSansPro12(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
          fontSize: 12,
          color: color ?? CustomColors.ebony,
          fontFamily: Fonts.sourceSansPro,
          fontWeight: fontWeight,
          height: height);

  static TextStyle textStyleSourceSansPro14(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
          fontSize: 14,
          color: color ?? CustomColors.bittersweet,
          fontFamily: Fonts.sourceSansPro,
          fontWeight: fontWeight,
          height: height);

  static TextStyle textStyleSourceSansPro16(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
          fontSize: 16,
          color: color ?? CustomColors.bittersweet,
          fontFamily: Fonts.sourceSansPro,
          fontWeight: fontWeight,
          height: height);

  static TextStyle textStyleSourceSansPro18(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
          fontSize: 18,
          color: color ?? CustomColors.pickledBluewood,
          fontFamily: Fonts.sourceSansPro,
          fontWeight: fontWeight,
          height: height);

  static TextStyle textStyleSourceSansPro20(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
          fontSize: 20,
          color: color ?? CustomColors.ebony,
          fontFamily: Fonts.sourceSansPro,
          fontWeight: fontWeight,
          height: height);

  static TextStyle textStyleShadowSourceSansPro20(
          {Color? color, FontWeight? fontWeight, double? height}) =>
      TextStyle(
        fontSize: 20,
        color: color ?? CustomColors.ebony,
        fontFamily: Fonts.sourceSansPro,
        fontWeight: fontWeight,
        height: height,
        shadows: [
          Shadow(
            blurRadius: 20.0, // shadow blur
            color: Colors.black, // shadow color
          ),
        ],
      );
}
