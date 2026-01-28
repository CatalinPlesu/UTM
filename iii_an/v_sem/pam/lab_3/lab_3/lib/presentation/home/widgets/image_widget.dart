import 'package:flutter/cupertino.dart';
import 'package:math_your_brain/resources/svg_assets.dart';

class ImageWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 16, right: 26, top:63, bottom: 44),
        child: SvgAssets.piPicture
    );
  }
}