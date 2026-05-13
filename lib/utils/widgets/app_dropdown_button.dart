import 'package:buraq_enterprise_employee/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropdownButton<T, V> extends StatefulWidget {
  const AppDropdownButton({
    super.key,
    required this.items,
    required this.valueNotifier,
    required this.onChanged,
    required this.itemLabel,
    required this.itemValue,
    required this.hint,
    this.height,
    required this.enabled,
    this.buttonBackgroundColor,
    this.dropdownBackgroundColor,
    this.label,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final List<T> items;
  final ValueNotifier<V?> valueNotifier;
  final void Function(V? value) onChanged;
  final String Function(T item) itemLabel;
  final V Function(T item) itemValue;
  final String hint;
  final double? height;
  final bool enabled;
  final Color? buttonBackgroundColor;
  final Color? dropdownBackgroundColor;
  final String? label;
  final String? Function(V? value)? validator;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppDropdownButton<T, V>> createState() =>
      AppDropdownButtonState<T, V>();
}

class AppDropdownButtonState<T, V> extends State<AppDropdownButton<T, V>> {
  // ─── We embed a FormField so it registers with the parent Form ───

  @override
  Widget build(BuildContext context) {
    final AppColorScheme appColors = context.appColors;

    return FormField<V>(
      initialValue: widget.valueNotifier.value,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<V> field) {
        final hasError = field.hasError;

        final dropDown = _buildDropdown(appColors, field, hasError);
        final dropdownWithError = _buildDropdownWithError(dropDown, field, hasError, appColors);

        return _buildWithLabel(dropdownWithError);
      },
    );
  }

  // ─── Dropdown widget ───────────────────────────────────────────────
  Widget _buildDropdown(
    AppColorScheme appColors,
    FormFieldState<V> field,
    bool hasError,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<V>(
        isExpanded: true,
        valueListenable: widget.valueNotifier,
        hint: AppTextBody(text: widget.hint, color: hasError? appColors.error: appColors.secondary),
        items: widget.items.map((T item) {
          return DropdownItem<V>(
            value: widget.itemValue(item),
            child: AppTextBody(text: widget.itemLabel(item)),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return widget.items.map((T item) {
            return AppTextBody(text: widget.itemLabel(item));
          }).toList();
        },
        onChanged: widget.enabled
            ? (value) {
                widget.valueNotifier.value = value; // keep notifier in sync
                field.didChange(value);              // notify the Form
                widget.onChanged(value);
              }
            : null,
        buttonStyleData: ButtonStyleData(
          elevation: 0,
          height: widget.height ?? 52,
          decoration: BoxDecoration(
            color: widget.buttonBackgroundColor ?? appColors.textFieldBgColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: hasError ? appColors.error : appColors.borderColor,
              width: hasError ? 1.5 : 1.0,
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, -5),
          elevation: 1,
          decoration: BoxDecoration(
            color: widget.dropdownBackgroundColor ?? appColors.chipColor,
            border: Border.all(color: appColors.borderColor),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: hasError ? appColors.error : null,
          ),
        ),
      ),
    );
  }

  // ─── Dropdown + error text below ──────────────────────────────────
  Widget _buildDropdownWithError(
    Widget dropDown,
    FormFieldState<V> field,
    bool hasError,
    AppColorScheme appColor
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        dropDown,
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.textFieldLabelMargin,
            ),
            child: AppTextBody(
              text:  field.errorText!,
              color: appColor.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  // ─── Optional label on top ────────────────────────────────────────
  Widget _buildWithLabel(Widget dropdownWithError) {
    if (widget.label != null && widget.label!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.textFieldLabelMargin,
            ),
            child: AppTextHeading(text: widget.label!, fontSize: 14),
          ),
          SizedBox(height: AppConstants.textFieldLabelMarginVertical),
          dropdownWithError,
        ],
      );
    }
    return dropdownWithError;
  }
}