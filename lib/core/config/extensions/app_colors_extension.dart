
import 'package:buraq_enterprise_employee/core/config/colors/app_color_scheme.dart';
import 'package:flutter/material.dart';

extension AppColorSchemeContext on BuildContext {
  AppColorScheme get appColors {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColorScheme.dark
        : AppColorScheme.light;
  }
}
