import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAssets{
  static SvgPicture piPicture =
  SvgPicture.asset(
    "resources/svg/pi_day.svg",
    fit: BoxFit.contain,
  );
  static SvgPicture clockPicture =
  SvgPicture.asset(
    "resources/svg/clock.svg",
    fit: BoxFit.contain,
  );
}
