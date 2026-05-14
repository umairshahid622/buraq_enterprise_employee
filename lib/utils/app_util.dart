import 'package:buraq_enterprise_employee/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_employee/core/config/colors/app_colors.dart';
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_spiner.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static Container getNameInitalsContainer({
    required String firstName,
    required String lastName,
    required AppColorScheme colorScheme,
    double size = 75.0,
  }) {
    final String firstNameInitial = AppHelper.getInitials(
      firstName,
    ).toUpperCase();
    final String lastNameInitial = AppHelper.getInitials(
      lastName,
    ).toUpperCase();
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
      ),
      child: AppTextHeading(
        text: "$firstNameInitial$lastNameInitial",
        fontSize: size / 2,
        color: AppColors.darkBorderColor,
      ),
    );
  }

  static void showToast({
    required String label,
    required ToastVariants variant,
  }) {
    final scaffoldState = AppConstants.scaffoldMessengerKey.currentState;
    if (scaffoldState == null || !scaffoldState.mounted) return;
    final context = scaffoldState.context;
    final Color backgroundColor;
    switch (variant) {
      case ToastVariants.success:
        backgroundColor = context.appColors.colorGreen;
        break;
      case ToastVariants.error:
        backgroundColor = context.appColors.error;
        break;
    }

    scaffoldState.showSnackBar(
      SnackBar(
        content: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        width: 280.0,
        duration: const Duration(seconds: 4),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
    );
  }

  static Container statusContainer({
    required BuildContext context,
    required String status,
    double? fontSize,
    AppColorScheme? colorScheme,
  }) {
    final colors = colorScheme ?? context.appColors;
    final Color bgColor;
    final Color textColor;
    if (status == Status.active.name) {
      bgColor = colors.colorGreen.withValues(alpha: 0.20);
      textColor = colors.colorGreen;
    } else if (status == Status.inactive.name) {
      bgColor = colors.error.withValues(alpha: 0.20);
      textColor = colors.error;
    } else if (status == Status.completed.name) {
      bgColor = colors.primary.withValues(alpha: 0.20);
      textColor = colors.primary;
    } else {
      bgColor = colors.secondary.withValues(alpha: 0.20);
      textColor = colors.secondary;
    }
    if (status.isEmpty) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: textColor, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Center(
        child: AppTextBody(text: status, color: textColor, fontSize: fontSize),
      ),
    );
  }

  static Expanded expenseCard(
    BuildContext context,
    String expenseType,
    int amount, {    
    AppColorScheme? colorScheme,
  }) {
    final colors = colorScheme ?? context.appColors;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: colors.chipColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextHeading(
                    text: expenseType,
                    fontSize: 14,
                    color: colors.secondary,
                  ),
                  SizedBox(height: 5),
                  AppTextHeading(
                    text: amount.toString(),
                    fontSize: 16,
                  ),
                ],
              ),
      ),
    );
  }

  static Widget noDataFound({
    required BuildContext context,
    required String heading,
    required String subHeading,
  }) {
    return Center(
      heightFactor: 3.5,
      child: Column(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: context.appColors.primary,
            size: 80,
          ),
          AppTextHeading(
            text: heading,
            textAlign: TextAlign.center,
            fontSize: 18,
          ),
          SizedBox(height: 2),
          AppTextBody(text: subHeading),
        ],
      ),
    );
  }

  static Widget noSearchFound({
    required BuildContext context,
    required String heading,
  }) {
    return Center(
      heightFactor: 3.5,
      child: Column(
        children: [
          Icon(
            Icons.search_rounded,
            color: context.appColors.primary,
            size: 80,
          ),
          AppTextHeading(
            text: heading,
            textAlign: TextAlign.center,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  static Divider divider({
    required AppColorScheme colorScheme,
    double thickness = 1.0,
  }) {
    return Divider(color: colorScheme.secondary, thickness: thickness);
  }

  static Container rsContainer({required BuildContext context}) {
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppTextBody(text: "Rs", fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  static Container iconContainer({required BuildContext context, required IconData icon}) {
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: context.appColors.colorBlue, size: 30),
    );
  }
}
