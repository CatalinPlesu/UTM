import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lab_4/resources/custom_collors.dart';

class SvgAssets {
  static SvgPicture commentSvg =
  SvgPicture.asset(
    "resources/svg/comment.svg",
    fit: BoxFit.contain,
  );

  static SvgPicture eyeSvg =
  SvgPicture.asset(
    "resources/svg/eye.svg",
    fit: BoxFit.contain,
  );

  static SvgPicture likeSvg =
  SvgPicture.asset(
    "resources/svg/like.svg",
    fit: BoxFit.contain,
  );

  static SvgPicture plusSvg =
  SvgPicture.asset(
    "resources/svg/plus.svg",
    fit: BoxFit.contain,
  );

  static SvgPicture bookmarkSvg =
  SvgPicture.asset(
    "resources/svg/mark.svg",
    fit: BoxFit.contain,
  );

  static SvgPicture backSvg =
  SvgPicture.asset(
    "resources/svg/back.svg",
    fit: BoxFit.contain,
  );
}