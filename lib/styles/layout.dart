import 'package:flutter/widgets.dart';

class SizeConfig {
  MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockWidth;
  static double blockHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height - 24; //minus 25 ( safe area )
    blockWidth = _mediaQueryData.size.width / 10;
    blockHeight = _mediaQueryData.size.height / 10;
  }
}
