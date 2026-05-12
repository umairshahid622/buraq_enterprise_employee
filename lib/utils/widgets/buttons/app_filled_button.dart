import 'package:buraq_enterprise_employee/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_spiner.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  final void Function()? onPressedCallBack;
  final String buttonText;
  final bool? isEnable;
  final bool? isLoading;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? fontSize;
  final Color? backgroundeColor;

  const AppFilledButton({
    super.key,
    required this.onPressedCallBack,
    required this.buttonText,
    this.isEnable,
    this.isLoading = false,
    this.buttonHeight,
    this.buttonWidth,
    this.fontSize,
    this.backgroundeColor,
  });

  @override
  Widget build(BuildContext context) {
    final AppColorScheme appColors = context.appColors;
    final Color bgColor = backgroundeColor ?? appColors.primary;
    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: buttonHeight ?? 48,
      child: FilledButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return bgColor.withValues(alpha: .35);
            }
            return bgColor;
          }),
        ),
        onPressed: (isLoading ?? false) || !(isEnable ?? true)
            ? null
            : onPressedCallBack,
        child: isLoading ?? false
            ? const Center(child: AppSpiner(size: 22))
            : AppTextBody(
                text: buttonText,
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? 16,
                color: bgColor == appColors.error ? Colors.white : appColors.colorButtonText,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
