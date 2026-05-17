import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/main_layout_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLayoutDataController>(
      init: Get.find<MainLayoutDataController>(),
      builder: (controller) {
        int allocatedBalance = controller.allocatedAmount.toInt();
        int spentBalance = controller.spentAmount.toInt();
        int availaibleBalance = allocatedBalance - spentBalance;

        final List<ProjectWithBudget> projectsWithBudget =
            controller.projectsWithBudget;
        final List<AddExpenseModel> expenses = controller.expenses;
        final bool isLoading =
            controller.isLoading.value || !controller.hasLoadedData;
        return RefreshIndicator(
          onRefresh: () {
            return controller.fetchData();
          },
          child: Skeletonizer(
            enabled: isLoading,
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
                  isLoading || projectsWithBudget.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTextHeading(text: "My Projects", fontSize: 16),
                            Visibility(
                              visible: projectsWithBudget.length > 2,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: AppTextButton(
                                buttonText: "View All",
                                onPressedCallBack: () {
                                  context.push(
                                    "/home/view-all",
                                    extra: {
                                      'isProject': true,
                                      'projects': projectsWithBudget,
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  isLoading || projectsWithBudget.isNotEmpty
                      ? SizedBox(height: AppConstants.commonVerticalSpacing / 2)
                      : SizedBox.shrink(),
                  isLoading || projectsWithBudget.isEmpty
                      ? AppUtils.noDataFound(
                          context: context,
                          heading: "No projects available",
                          subHeading: "Ask you admin to assign you a project",
                        )
                      : AppUtils.projectList(
                          projects: controller.projectsWithBudget,
                          projectLength: 2,
                        ),
                  SizedBox(height: AppConstants.commonVerticalSpacing / 2),
                  expenses.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTextHeading(
                              text: "Recent Expenses",
                              fontSize: 16,
                            ),
                            Visibility(
                              visible: expenses.length > 2,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,

                              child: AppTextButton(
                                buttonText: "View All",
                                onPressedCallBack: () {
                                  context.push(
                                    "/home/view-all",
                                    extra: {
                                      'isProject': false,
                                      'expenses': expenses,
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  expenses.isNotEmpty
                      ? SizedBox(height: AppConstants.commonVerticalSpacing / 2)
                      : SizedBox.shrink(),
                  expenses.isNotEmpty
                      ? AppUtils.expenseList(
                          expenses: expenses,
                          expenseLength: 2,
                        )
                      : SizedBox.shrink(),
                ],
              ),
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
      onTap: () {
        AppHelper.printActiveControllers();
      },
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
          AppTextHeading(
            text: AppHelper.formatPKR(availaibleBalance),
            fontSize: 28,
            color: availaibleBalance < 0
                ? context.appColors.error
                : context.appColors.text,
          ),
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
