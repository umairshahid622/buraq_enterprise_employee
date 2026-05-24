import 'package:buraq_enterprise_employee/core/config/colors/app_colors.dart';
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/screen/auth/controllers/login/login_controller.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_text_button.dart';
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
        child: Column(
          children: [
            _appIcon(context: context),
            SizedBox(height: spacing),
            AppTextHeading(text: "Employee Login"),
            SizedBox(height: spacing),          
            loginForm(controller: controller, spacing: spacing),
            SizedBox(height: spacing),
            AppTextBody(text: "Credentials provided by admin"),
          ],
        ),
      ),
    );
  }

  Form loginForm({required LoginController controller, double? spacing}) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          AppTextField(
            controller: controller.emailController,
            type: TextFieldType.email,
            hintText: "Enter Your Email Address",
            labelText: "Email Address",
          ),
          SizedBox(height: spacing != null ? spacing / 2 : null),
          Obx(
            () => AppTextField(
              controller: controller.passwordController,
              type: TextFieldType.password,
              hintText: "Enter Your Password",
              labelText: "Password",
              obscureText: controller.obscureText.value,
              onSuffixTap: () {
                controller.obscureText.value = !controller.obscureText.value;
              },
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: AppTextButton(buttonText: "Forgot Password?"),
          ),
          SizedBox(height: spacing),
          _continueButton(controller, context),
        ],
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

  Widget _continueButton(LoginController controller, BuildContext context) {
    return Obx(() {
      return AppFilledButton(
        isLoading: controller.isLoading.value,
        buttonText: "Continue",
        onPressedCallBack: () =>controller.login(),
      );
    });
  }
}
