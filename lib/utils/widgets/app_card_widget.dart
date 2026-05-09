
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AppCardWidget extends StatelessWidget {
  final Widget cardWidget;
  final void Function()? onTap;
  final Color? borderColor;
  const AppCardWidget({
    super.key,
    required this.cardWidget,
    this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? context.appColors.borderColor;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppConstants.padding * 1.5,
          horizontal: AppConstants.padding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: border,
            width: AppConstants.borderStroke,
          ),
        ),
        child: cardWidget,
      ),
    );
  }
}
