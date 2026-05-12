import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/utils/classes/app_dropdown_button_class.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropdownButton extends StatelessWidget {
  const AppDropdownButton({
    super.key,
    required this.items,
    required this.valueNotifier,
    required this.onChanged,
    required this.hint,
    this.height,
    required this.enabled,
    this.buttonBackgroundColor,
    this.dropdownBackgroundColor,
    this.label,
  });

  final List<AppDropdownButtonClass> items;
  final ValueNotifier<String?> valueNotifier;
  final void Function(String? value) onChanged;
  final String hint;
  final double? height;
  final bool enabled;
  final Color? buttonBackgroundColor;
  final Color? dropdownBackgroundColor;

  final String? label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final DropdownButtonHideUnderline dropDown = DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        valueListenable: valueNotifier,
        hint: AppTextBody(text: hint, color: appColors.secondary),
        items: items.map((item) {
          return DropdownItem<String>(
            value: item.id,
            child: AppTextBody(text: item.label),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return items.map((item) {
            return AppTextBody(text: item.label);
          }).toList();
        },
        onChanged: enabled ? onChanged : null,
        buttonStyleData: ButtonStyleData(
          elevation: 0,
          height: height ?? 52,
          decoration: BoxDecoration(
            color: buttonBackgroundColor ?? appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: appColors.borderColor),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, -5),
          elevation: 1,
          decoration: BoxDecoration(
            color: dropdownBackgroundColor ?? appColors.chipColor,
            border: Border.all(color: appColors.borderColor),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );

    if (label != null || label!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.textFieldLabelMargin,
            ),
            child: AppTextHeading(text: label!, fontSize: 14),
          ),
          SizedBox(height: AppConstants.textFieldLabelMarginVertical),
          dropDown,
        ],
      );
    } else {
      return dropDown;
    }
  }
}
