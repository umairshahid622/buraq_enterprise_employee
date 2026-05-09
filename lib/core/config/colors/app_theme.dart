
import 'package:buraq_enterprise_employee/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // -------------------- LIGHT THEME --------------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorScheme.light.background,

    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: AppColorScheme.light.background,
      foregroundColor: AppColorScheme.light.text,
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(style: BorderStyle.none),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.light.primary;
        }
        return AppColorScheme.light.borderColor;
      }),
    ),

    cardTheme: CardThemeData(
      color: AppColorScheme.light.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: AppColorScheme.light.borderColor.withValues(alpha: .2),
        ),
      ),
      margin: const EdgeInsets.all(0),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColorScheme.light.primary,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColorScheme.light.background,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: AppColorScheme.light.primary,
      headerForegroundColor: Colors.white,
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.light.primary;
        }
        return null;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColorScheme.light.text;
      }),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.dark.primary; // Fill it ONLY if selected
        }
        return Colors.transparent; // No background otherwise
      }),

      
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.dark.background; // Contrast text if selected
        }
        return AppColorScheme
            .dark
            .primary; // Primary color text if not selected
      }),
      todayBorder: BorderSide(color: AppColorScheme.light.primary),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 1,
      backgroundColor: AppColorScheme.light.background,
      selectedItemColor: AppColorScheme.light.primary,
      unselectedItemColor: AppColorScheme.light.secondary,
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );

  // -------------------- DARK THEME --------------------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorScheme.dark.background,

    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: AppColorScheme.dark.background,
      foregroundColor: AppColorScheme.dark.text,
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(style: BorderStyle.none),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.dark.primary;
        }
        return AppColorScheme.dark.borderColor;
      }),
    ),

    cardTheme: CardThemeData(
      color: AppColorScheme.dark.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(color: AppColorScheme.dark.borderColor.withAlpha(20)),
      ),
      margin: const EdgeInsets.all(0),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColorScheme.dark.primary,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColorScheme.dark.background,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: AppColorScheme.dark.primary,
      headerForegroundColor:
          AppColorScheme.dark.background, // Text on the colored header
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.dark.primary;
        }
        return null;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.dark.background;
        }
        return AppColorScheme.dark.text;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.dark.background; // Contrast text if selected
        }
        return AppColorScheme
            .dark
            .primary; // Primary color text if not selected
      }),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorScheme.dark.primary; // Fill it ONLY if selected
        }
        return Colors.transparent; // No background otherwise
      }),
      todayBorder: BorderSide(color: AppColorScheme.dark.primary),
      // Optional: match the cancel/save button colors
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColorScheme.dark.primary),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColorScheme.dark.primary),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 1,
      backgroundColor: AppColorScheme.dark.background,
      selectedItemColor: AppColorScheme.dark.primary,
      unselectedItemColor: AppColorScheme.dark.secondary,
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}
