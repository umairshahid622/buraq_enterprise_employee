import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextHeading extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  const AppTextHeading({
    super.key,
    required this.text,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.bold,
    this.textAlign,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = color ?? context.appColors.text;
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.quicksand(
        fontSize: fontSize,
        height: 1,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }
}

class AppTextBody extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  const AppTextBody({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = color ?? context.appColors.secondary;
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        height: 1.5,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }
}

class AppRichText extends StatelessWidget {
  const AppRichText({super.key, required this.text1, required this.text2});

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text1 ,
        style: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: context.appColors.secondary,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text2,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: context.appColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
