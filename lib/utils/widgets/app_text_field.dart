
import 'package:buraq_enterprise_employee/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
  final TextFieldType type;
  final TextEditingController controller;
  final bool? autoFocus;
  final bool? obscureText;
  final bool readOnly;
  final bool enabled;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final String? labelText;
  final String? hintText;
  final TextAlign? textAlign;
  final double? borderRadius;
  final int? maxLength;
  final String? counterText;
  final FontWeight? fontWeight;
  final FocusNode? focusNode;
  final int? maxLines;
  final Function(String value)? onTextChangeCallBack;
  final Function()? onTapCallBack;
  final Function(KeyEvent event)? onKeyEvent; // 👈 add this

  const AppTextField({
    super.key,
    this.type = TextFieldType.text,
    required this.controller,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.obscureText,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTextChangeCallBack,
    this.onTapCallBack,
    this.autoFocus,
    this.paddingHorizontal,
    this.paddingVertical,
    this.textAlign,
    this.borderRadius,
    this.maxLength,
    this.counterText,
    this.fontWeight,
    this.focusNode,
    this.onKeyEvent, this.maxLines,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    // only create if needed
    if (widget.onKeyEvent != null) {
      _keyboardFocusNode = FocusNode(skipTraversal: true);
    }
  }

  @override
  void dispose() {
    if (widget.onKeyEvent != null) {
      _keyboardFocusNode.dispose(); // properly disposed
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextInputType keyBoardType;
    final Widget? defaultPrefixIcon;
    final List<TextInputFormatter>? inputFormatters;

    switch (widget.type) {
      case TextFieldType.email:
        keyBoardType = TextInputType.emailAddress;
        inputFormatters = [];
        defaultPrefixIcon = null;
        break;
      case TextFieldType.otp:
        keyBoardType = TextInputType.number;
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1), // 👈 otp specific
        ];
        defaultPrefixIcon = null;
        break;
      case TextFieldType.amount:
        keyBoardType = TextInputType.number;
        inputFormatters = [];
        defaultPrefixIcon = null;
        break;
      case TextFieldType.phoneNumber:
        keyBoardType = TextInputType.phone;
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ];
        defaultPrefixIcon = const Icon(Icons.phone);
        break;      
       case TextFieldType.notes:
        keyBoardType = TextInputType.multiline;
        inputFormatters = [];
        defaultPrefixIcon = null;
        break;
      default:
        keyBoardType = TextInputType.text;
        defaultPrefixIcon = const Icon(Icons.edit_note_rounded);
        inputFormatters = [];
        break;
    }

    final AppColorScheme appColorScheme = context.appColors;

    Widget textField = TextFormField(
      maxLines: widget.maxLines,
      inputFormatters: inputFormatters,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      readOnly: widget.readOnly,
      onTap: widget.onTapCallBack ?? () {},
      enabled: widget.enabled,
      textAlign: widget.textAlign ?? TextAlign.start,
      autofocus: widget.autoFocus ?? false,
      maxLength: widget.maxLength,
      focusNode: widget.focusNode,
      obscureText: widget.type == TextFieldType.password
          ? (widget.obscureText ?? true)
          : false,
      controller: widget.controller,
      keyboardType: keyBoardType,
      onChanged: widget.onTextChangeCallBack,
      validator: (value) {
        if (widget.type == TextFieldType.phoneNumber) {
          return AppHelper.phoneNumberValidator(value: value ?? "");
        } else if (widget.type == TextFieldType.text) {
          return AppHelper.textValidator(value: value ?? "");
        } else if (widget.type == TextFieldType.amount) {
          return AppHelper.amountValidator(value: int.tryParse(value ?? ""));
        } else if (widget.type == TextFieldType.otp) {
          // 👇 otp validation — empty string hides error text but still blocks submit
          if (value == null || value.isEmpty) return '';
          return null;
        } else {
          return null;
        }
      },
      style: GoogleFonts.inter(
        fontWeight: widget.fontWeight ?? FontWeight.normal,
        fontSize: widget.type == TextFieldType.otp
            ? 20
            : null, // 👈 bigger font for otp
      ),
      cursorColor: WidgetStateColor.resolveWith((state) {
        if (state.contains(WidgetState.error)) return appColorScheme.error;
        return appColorScheme.primary;
      }),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon ?? defaultPrefixIcon,
        suffixIcon: widget.suffixIcon,
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppConstants.borderRadius,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppConstants.borderRadius,
          ),
          borderSide: BorderSide(color: appColorScheme.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppConstants.borderRadius,
          ),
          borderSide: BorderSide(color: appColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppConstants.borderRadius,
          ),
          borderSide: BorderSide(
            color: appColorScheme.error.withValues(alpha: .4),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? AppConstants.borderRadius,
          ),
          borderSide: BorderSide(
            color: appColorScheme.error.withValues(alpha: .4),
            width: 2,
          ),
        ),
        prefixIconColor: WidgetStateColor.resolveWith((state) {
          if (state.contains(WidgetState.error)) return appColorScheme.error;
          return appColorScheme.text;
        }),
        contentPadding: EdgeInsets.symmetric(
          horizontal:
              widget.paddingHorizontal ??
              (widget.type == TextFieldType.otp ? 0 : 16),
          vertical: widget.paddingVertical ?? 14,
        ),
        hintStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return GoogleFonts.inter(color: appColorScheme.error);
          }
          return GoogleFonts.inter(color: appColorScheme.secondary);
        }),
      ),
    );

    if (widget.onKeyEvent != null) {
      textField = KeyboardListener(
        focusNode: _keyboardFocusNode,
        onKeyEvent: widget.onKeyEvent!,
        child: textField,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.textFieldLabelMargin,
            ),
            child: AppTextHeading(text: widget.labelText!, fontSize: 14),
          ),
          SizedBox(height: AppConstants.textFieldLabelMarginVertical),
        ],
        textField,
      ],
    );
  }
}
