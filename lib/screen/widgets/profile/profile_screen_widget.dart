import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/screen/controllers/profile/profile_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreenWidget extends StatelessWidget {
  const ProfileScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileScreenController>(
      init: ProfileScreenController(),
      dispose: (state) => Get.delete<ProfileScreenController>(),
      builder: (controller) {
        return AppScrollableBody(
          child: Column(children: [employeeCard(controller, context), 
            SizedBox(height: AppConstants.commonVerticalSpacing),
           Obx(()=> AppFilledButton(
            isLoading: controller.isLogoutProcessing.value,
            onPressedCallBack: controller.logout, buttonText: "Logout")),
          ]),
        );
      },
    );
  }

  AppCardWidget employeeCard(
    ProfileScreenController controller,
    BuildContext context,
  ) {
    return AppCardWidget(
      cardWidget: Column(
        children: [
          Row(
            children: [
              AppUtils.getNameInitalsContainer(
                firstName: controller.user.firstName,
                lastName: controller.user.lastName,
                colorScheme: context.appColors,
              ),
              SizedBox(width: AppConstants.commonHorizontalSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextHeading(
                    text:
                        '${controller.user.firstName} ${controller.user.lastName}',
                  ),
                  AppTextBody(text: controller.user.empId),
                ],
              ),
            ],
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          AppUtils.divider(colorScheme: context.appColors),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          contactRow(context: context, text: controller.user.phoneNumber),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          contactRow(
            context: context,
            text: "0 Active Projects",
            icon: Icons.work_outline,
          ),
        ],
      ),
    );
  }

  Row contactRow({
    required BuildContext context,
    required String text,
    IconData icon = Icons.phone,
  }) {
    return Row(
      children: [
        Icon(icon, color: context.appColors.secondary),
        SizedBox(width: AppConstants.commonHorizontalSpacing),
        AppTextBody(text: text, color: context.appColors.text),
      ],
    );
  }
}
