
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/screen/auth/login_controller.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpBottomSheetWidget extends StatelessWidget {
  const OtpBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      padding: EdgeInsets.all(AppConstants.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppTextHeading(text: "Verify OTP"),
          const SizedBox(height: 10),
          const AppTextBody(text: "Enter the 6-digit code sent to your phone"),
          const SizedBox(height: 20),
          otpForm(controller, context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget otpForm(LoginController controller, BuildContext context) {
    return Form(
      key: controller.otpFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.otpLength, (index) {
              final isFirst = index == 0;
              final isLast = index == controller.otpLength - 1;

              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AppTextField(
                    type: TextFieldType.otp,
                    controller: controller.otpControllers[index],
                    focusNode: controller.otpFocusNodes[index],
                    textAlign: TextAlign.center,
                    autoFocus: isFirst,
                    onKeyEvent: (event) {
                      // handle backspace when field is empty
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace &&
                          controller.otpControllers[index].text.isEmpty &&
                          !isFirst) {
                        controller.otpFocusNodes[index - 1].requestFocus();
                      }
                    },
                    onTextChangeCallBack: (value) {
                      if (value.isNotEmpty) {
                        if (!isLast) {
                          controller.otpFocusNodes[index + 1].requestFocus();
                        } else {
                          controller.otpFocusNodes[index].unfocus();
                        }
                      } else if (value.isEmpty && !isFirst) {
                        controller.otpFocusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Obx(
            () => AppFilledButton(
              isLoading: controller.isLoading.value,
              isEnable: !controller.isLoading.value,
              buttonText: "Verify Now",
              onPressedCallBack: () async {
                await controller.verifyOtp();
              },
            ),
          ),
        ],
      ),
    );
  }
}
