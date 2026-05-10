
import 'package:buraq_enterprise_employee/core/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class AppColorScheme {
  final Color colorButtonText;

  // Primary colors
  final Color primary;
  final Color colorGreen;
  final Color colorBlue;

  // Secondary colors
  final Color secondary;

  // Error colors
  final Color error;
  final Color onError;

  // Background & Surface colors
  final Color background;
  final Color text;
  final Color chipColor;
  final Color textFieldBgColor;

  // Border
  final Color borderColor;

  // Brightness
  final Brightness brightness;

  const AppColorScheme({
    required this.primary,
    required this.colorGreen,
    required this.colorBlue,
    required this.secondary,
    required this.error,
    required this.onError,
    required this.background,
    required this.text,
    required this.chipColor,
    required this.textFieldBgColor,
    required this.borderColor,
    required this.brightness,
    required this.colorButtonText,
  });

  /// Light scheme
  static const AppColorScheme light = AppColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
    onError: AppColors.onErrorLight,
    background: AppColors.lightBg,
    text: AppColors.lightOn,
    textFieldBgColor: AppColors.textFieldLightBgColor,
    borderColor: AppColors.lightBorderColor,
    chipColor: AppColors.lightChipColor,
    colorGreen: AppColors.colorGreenLight,
    colorBlue: AppColors.colorBlueLight,
    colorButtonText: AppColors.colorButtonText,
    brightness: Brightness.light,
  );

  /// Dark scheme
  static const AppColorScheme dark = AppColorScheme(
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
    error: AppColors.error,
    onError: AppColors.onErrorDark,
    background: AppColors.darkBg,
    text: AppColors.darkOn,
    textFieldBgColor: AppColors.textFieldDarkBgColor,
    borderColor: AppColors.darkBorderColor,
    chipColor: AppColors.darkChipColor,
    colorGreen: AppColors.colorGreenDark,
    colorBlue: AppColors.colorBlueDark,
    colorButtonText: AppColors.colorButtonText,
    brightness: Brightness.dark,
  );
  
  static AppColorScheme of() {
    final controller = Get.find<ThemeController>();

    return controller.isDarkMode.value ? dark : light;
  }
}
