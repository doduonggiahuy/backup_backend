import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/theme_service.dart';
import 'app_colors.dart';

class AppTheme {
  final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColor.white,
      secondary: AppColor.white,
      inversePrimary: AppColor.black,
      onPrimary: AppColor.lightGrey,
      outline: AppColor.grey,
      shadow: AppColor.black,
    ),
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColor.black,
      secondary: AppColor.darkGrey,
      onPrimary: AppColor.grey,
      inversePrimary: AppColor.darkGrey,
      outline: AppColor.white,
      shadow: AppColor.white,
    ),
  );

  final ThemeService _themeService = ThemeService();

  Future<ThemeMode> loadTheme() async {
    return await _themeService.loadThemeMode();
  }

  void switchTheme() {
    ThemeMode currentTheme = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(currentTheme);
    _themeService.saveThemeMode(currentTheme);
  }
}
