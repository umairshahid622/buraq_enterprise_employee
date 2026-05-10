import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/screen/controllers/profile/profile_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
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
          child: Column(children: [employeeCard(controller, context)]),
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
          AppUtils.divider(),
        ],
      ),
    );
  }
}
