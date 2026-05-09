// lib/utils/widgets/app_multi_select_dropdown.dart

import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/utils/classes/multi_select_item.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';


class AppMultiSelectDropdown extends StatelessWidget {
  final List<MultiSelectItem> items;
  final List<String> selectedIds;
  final String hint;
  final double? height;
  final void Function(String id) onToggle;
  final String? Function(List<String>?)? validator;

  const AppMultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onToggle,
    this.hint = 'Select',
    this.height,
    this.validator,
  });

  String get _displayText {
    if (selectedIds.isEmpty) return hint;
    return items
        .where((e) => selectedIds.contains(e.id))
        .map((e) => e.label)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return FormField<List<String>>(
      validator: validator,
      builder: (FormFieldState<List<String>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: AppTextBody(
                  text: _displayText,
                  color: appColors.secondary,
                ),
                items: items.isEmpty
                    ? [
                        DropdownItem<String>(
                          value: '',
                          enabled: false,
                          child: AppTextBody(
                            text: "No items available",
                            color: appColors.secondary,
                          ),
                        ),
                      ]
                    : items.map((item) {
                        return DropdownItem<String>(
                          value: item.id,
                          enabled: false,
                          child: StatefulBuilder(
                            builder: (context, menuSetState) {
                              final isSelected = selectedIds.contains(item.id);
                              return InkWell(
                                onTap: () {
                                  onToggle(item.id);
                                  state.didChange(selectedIds);
                                  menuSetState(() {});
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AppTextBody(
                                          text: item.label,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Icon(
                                        Icons.check,
                                        size: 16,
                                        color: isSelected
                                            ? appColors.primary
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                onChanged: (_) {},
                selectedItemBuilder: (context) {
                  return items.map((_) {
                    return AppTextBody(text: _displayText);
                  }).toList();
                },
                buttonStyleData: ButtonStyleData(
                  elevation: 0,
                  height: height ?? 52,
                  decoration: BoxDecoration(
                    color: appColors.textFieldBgColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    border: Border.all(
                      color: state.hasError
                          ? Colors.red
                          : appColors.borderColor,
                    ),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  offset: const Offset(0, -5),
                  maxHeight: 280,
                  elevation: 1,
                  decoration: BoxDecoration(
                    color: appColors.chipColor,
                    border: Border.all(color: appColors.borderColor),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: AppTextBody(
                  text: state.errorText!,
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        );
      },
    );
  }
}
