import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropdownButton<T, V> extends StatelessWidget {
  const AppDropdownButton({
    super.key,
    required this.items, // The list of any objects
    required this.valueNotifier, // Notifier for the selected ID
    required this.onChanged,
    required this.itemLabel, // Function to tell us what text to show
    required this.itemValue, // Function to tell us which field is the ID
    required this.hint,
    this.height,
    required this.enabled,
    this.buttonBackgroundColor,
    this.dropdownBackgroundColor,
    this.label,
  });

  final List<T> items;
  final ValueNotifier<V?> valueNotifier;
  final void Function(V? value) onChanged;
  final String Function(T item) itemLabel; // Extracts display text
  final V Function(T item) itemValue; // Extracts the ID/Value

  final String hint;
  final double? height;
  final bool enabled;
  final Color? buttonBackgroundColor;
  final Color? dropdownBackgroundColor;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final dropDown = DropdownButtonHideUnderline(
      child: DropdownButton2<V>(
        // V is the type of the ID (usually String)
        isExpanded: true,
        valueListenable: valueNotifier,
        hint: AppTextBody(text: hint, color: appColors.secondary),
        items: items.map((T item) {
          return DropdownItem<V>(
            value: itemValue(item), // Dynamic ID
            child: AppTextBody(text: itemLabel(item)), // Dynamic Label
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return items.map((T item) {
            return AppTextBody(text: itemLabel(item));
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
