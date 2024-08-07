import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColor {
  AppColor._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF0F0F0);
  static const Color darkGrey = Color(0xFF3C3C3C);
  static const Color blue = Color(0xFF3641B7);
  static const Color lightBlue = Color(0xFF4481FF);
  static const Color transparent = Color(0x00000000);
  static const Color red = Color(0xffEB2525);
  static const Color green = Color(0xff146b4a);
  static const Color orange = Colors.orange;
  static Color greyButton = const Color.fromARGB(255, 233, 233, 233);

  static Color getThemeColor(Color color) {
    return Get.isDarkMode ? invertColor(color) : color;
  }

  static Color invertColor(Color color) {
    return Color.fromRGBO(
        255 - color.red, 255 - color.green, 255 - color.blue, 1);
  }
}
