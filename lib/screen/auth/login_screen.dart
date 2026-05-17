import 'package:buraq_enterprise_employee/core/config/colors/app_colors.dart';
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/screen/auth/login_controller.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_employee/utils/widgets/bottom_sheet.dart/widget/otp_bottom_sheet_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  void dispose() {
    Get.delete<LoginController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.03;
    return AppScrollableBody(
      centerContent: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.padding),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _appIcon(context: context),
              SizedBox(height: spacing),
              AppTextHeading(text: "Employee Login"),
              SizedBox(height: spacing),
              _phoneNumberField(controller),
              SizedBox(height: spacing),
              _continueButton(controller, context),
              SizedBox(height: spacing),
              AppTextBody(text: "Credentials provided by admin"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appIcon({required BuildContext context}) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        color: colors.primary,
      ),
      child: const Icon(
        Icons.construction_rounded,
        size: 40,
        color: AppColors.darkBg,
      ),
    );
  }

  AppTextField _phoneNumberField(LoginController controller) {
    return AppTextField(
      prefixIcon: const Icon(Icons.phone),
      type: TextFieldType.phoneNumber,
      controller: controller.phoneNumberController,
      hintText: "Enter Your Phone Number",
    );
  }

  Widget _continueButton(LoginController controller, BuildContext context) {
    return Obx(() {
      return AppFilledButton(
        isLoading: controller.verifyNumberLoading.value,
        buttonText: "Continue",
        onPressedCallBack: () {
          controller.verifyPhoneNumber((verId) {
            if (!context.mounted) return;
            showModalBottomSheet(
              
              backgroundColor: Colors.black.withValues(alpha: 0.25),
              barrierColor: Colors.transparent,
              elevation: 10.0,
              context: context,
              isDismissible: true,
              builder: (BuildContext context) {
                return OtpBottomSheetWidget();
              },
            ).whenComplete(() {
              controller.resetOtpFlow();
            });
          });
        },
      );
    });
  }
}
