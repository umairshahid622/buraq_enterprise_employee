import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/screen/controllers/splash/splash_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SplashScreenWidget extends GetView<SplashController> {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        controller.checkVersion(context);
      }
    });

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: screenHeight * 0.175,
              color: context.appColors.primary,
            ),
            SizedBox(height: AppConstants.commonVerticalSpacing),
            AppTextHeading(
              text: "Buraq Enterprise Employee",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
