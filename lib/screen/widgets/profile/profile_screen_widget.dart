import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/screen/controllers/profile/profile_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProfileScreenWidget extends StatelessWidget {
  const ProfileScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileScreenController>(
      init: ProfileScreenController(),
      dispose: (state) => Get.delete<ProfileScreenController>(),
      builder: (controller) {
        return AppScrollableBody(
          child: Column(
            children: [
              employeeCard(controller, context),
              SizedBox(height: AppConstants.commonVerticalSpacing),
              workSummaryCard(controller, context),
              SizedBox(height: AppConstants.commonVerticalSpacing),
              AppFilledButton(                
                onPressedCallBack: () {
                  AppUtils.appDialog(
                    context: context,
                    onSubmitCallBack: () async {
                      await controller.logout();
                    },
                    onCancelCallBack: () {
                      context.pop();
                    },
                    isLoading: () => controller.isLogoutProcessing.value,
                    icon: Icons.logout,
                    title: "Log Out?",
                    message: "Are you sure you want to logout? Any unsaved data will be lost.",
                    subMessage: "" ,
                    submitButtonText: "Logout",
                  );
                },
                buttonText: "Logout",
              ),

              SizedBox(height: AppConstants.commonVerticalSpacing),
            ],
          ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextHeading(
                      text:
                          '${controller.user.firstName} ${controller.user.lastName}',
                    ),
                    AppTextBody(text: controller.user.empId),
                  ],
                ),
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
            text: controller.activeProjectsLabel,
            icon: Icons.work_outline,
          ),
        ],
      ),
    );
  }

  AppCardWidget workSummaryCard(
    ProfileScreenController controller,
    BuildContext context,
  ) {
    return AppCardWidget(
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextHeading(text: "Work Summary", fontSize: 18),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          Row(
            children: [
              summaryTile(
                context: context,
                title: "Projects",
                value: controller.totalProjectCount.toString(),
                icon: Icons.folder_open_outlined,
              ),
              SizedBox(width: AppConstants.commonHorizontalSpacing),
              summaryTile(
                context: context,
                title: "Expenses",
                value: controller.expenseCount.toString(),
                icon: Icons.receipt_long_outlined,
              ),
            ],
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          Row(
            children: [
              summaryTile(
                context: context,
                title: "Allocated",
                value: AppHelper.formatPKR(controller.allocatedAmount),
                icon: Icons.account_balance_wallet_outlined,
              ),
              SizedBox(width: AppConstants.commonHorizontalSpacing),
              summaryTile(
                context: context,
                title: "Available",
                value: AppHelper.formatPKR(controller.availableAmount),
                icon: Icons.savings_outlined,
                valueColor: controller.availableAmount < 0
                    ? context.appColors.error
                    : context.appColors.colorGreen,
              ),
            ],
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          AppUtils.divider(colorScheme: context.appColors),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          infoRow(
            context: context,
            label: "Role",
            value: controller.user.role.isEmpty
                ? "Employee"
                : controller.user.role,
            icon: Icons.badge_outlined,
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          infoRow(
            context: context,
            label: "Status",
            value: controller.user.status.isEmpty
                ? "active"
                : controller.user.status,
            icon: Icons.verified_user_outlined,
          ),
        ],
      ),
    );
  }

  Expanded summaryTile({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppConstants.padding),
        decoration: BoxDecoration(
          color: context.appColors.chipColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.appColors.primary),
            SizedBox(height: AppConstants.commonVerticalSpacing / 2),
            AppTextBody(text: title, color: context.appColors.secondary),
            SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: AppTextHeading(
                  text: value,
                  fontSize: 18,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row infoRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: context.appColors.secondary),
        SizedBox(width: AppConstants.commonHorizontalSpacing),
        AppTextBody(text: label, color: context.appColors.secondary),
        Spacer(),
        AppTextHeading(text: value, fontSize: 15),
      ],
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
