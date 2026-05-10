import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/screen/controllers/home/home_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      init: HomeScreenController(),
      dispose: (controller) => controller.dispose(),
      builder: (controller) {
        int allocatedBalance = controller.allocatedAmount.toInt();
        int spentBalance = controller.spentAmount.toInt();
        int availaibleBalance = allocatedBalance - spentBalance;
        return Skeletonizer(
          enabled: controller.isLoading.value,

          child: AppScrollableBody(
            child: Column(
              children: [
                balanceCard(
                  context,
                  availaibleBalance,
                  allocatedBalance,
                  spentBalance,
                ),
                SizedBox(height: AppConstants.commonVerticalSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextHeading(text: "My Projects", fontSize: 16),
                    AppTextButton(buttonText: "View All"),
                  ],
                ),
                SizedBox(height: AppConstants.commonVerticalSpacing / 2),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.projects.length,
                  itemBuilder: (context, index) {
                    final project = controller.projects[index];
                    final totalBudget = 0;
                    final spentBudget = 0;
                    final double progressValue = AppHelper.calculatePercentage(
                      spentBudget,
                      totalBudget,
                    );
                    return AppCardWidget(
                      onTap: () {
                        print(controller.allocatedAmounts.map((e) => e.toJson()).toList());
                        print(controller.projects.map((e) => e.toMap()).toList());
                      },
                      verticalPadding: AppConstants.padding,
                      cardWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: AppTextHeading(
                                  text: project.projectName,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: AppConstants.commonHorizontalSpacing,
                              ),
                              AppUtils.statusContainer(
                                context: context,
                                status: project.status,
                              ),
                            ],
                          ),
                          AppTextBody(text: project.projectId, fontSize: 14),
                          SizedBox(height: AppConstants.commonVerticalSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextBody(text: "Budget Used"),
                              AppTextBody(
                                text: '${progressValue.round()}%',
                                color: context.appColors.text,
                              ),
                            ],
                          ),
                          SizedBox(height: AppConstants.commonVerticalSpacing/4),
                          LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(12),
                            value: progressValue / 100,
                            minHeight: 6.5,
                            backgroundColor: context.appColors.borderColor,
                          ),
                          SizedBox(height: AppConstants.commonVerticalSpacing/4),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppCardWidget balanceCard(
    BuildContext context,
    int availaibleBalance,
    int allocatedBalance,
    int spentBalance,
  ) {
    return AppCardWidget(
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wallet_rounded, color: context.appColors.primary),
              SizedBox(width: AppConstants.commonHorizontalSpacing),
              AppTextBody(text: "Availaible Balance"),
            ],
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          AppTextHeading(text: AppHelper.formatPKR(availaibleBalance)),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppRichText(
                text1: "Allocated: ",
                text2: AppHelper.formatPKR(allocatedBalance),
              ),
              AppRichText(
                text1: "Spent: ",
                text2: AppHelper.formatPKR(spentBalance),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
