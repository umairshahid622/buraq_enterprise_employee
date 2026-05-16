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
      init: MainLayoutDataController(),
      builder: (controller) {
        int allocatedBalance = controller.allocatedAmount.toInt();
        int spentBalance = controller.spentAmount.toInt();
        int availaibleBalance = allocatedBalance - spentBalance;

        final List<ProjectWithBudget> projectsWithBudget =
            controller.projectsWithBudget;
        final List<AddExpenseModel> expenses = controller.expenses;
        return RefreshIndicator(
          onRefresh: () {
            return controller.fetchData();
          },
          child: Skeletonizer(
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
                  projectsWithBudget.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTextHeading(text: "My Projects", fontSize: 16),
                            AppTextButton(buttonText: "View All"),
                          ],
                        )
                      : SizedBox.shrink(),
                  projectsWithBudget.isNotEmpty
                      ? SizedBox(height: AppConstants.commonVerticalSpacing / 2)
                      : SizedBox.shrink(),
                  projectsWithBudget.isEmpty
                      ? AppUtils.noDataFound(
                          context: context,
                          heading: "No projects available",
                          subHeading: "Ask you admin to assign you a project",
                        )
                      : projectList(controller),
                  SizedBox(height: AppConstants.commonVerticalSpacing / 2),
                  expenses.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTextHeading(
                              text: "Recent Expenses",
                              fontSize: 16,
                            ),
                            AppTextButton(buttonText: "View All"),
                          ],
                        )
                      : SizedBox.shrink(),
                  expenses.isNotEmpty
                      ? SizedBox(height: AppConstants.commonVerticalSpacing / 2)
                      : SizedBox.shrink(),
                  expenses.isNotEmpty
                      ? expenseList(expenses)
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ListView expenseList(List<AddExpenseModel> expenses) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return AppCardWidget(
          onTap: () {
            context.push("/home/manage-expense", extra: expenses[index]);
          },
          cardWidget: Column(
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppUtils.rsContainer(context: context),
                      SizedBox(width: AppConstants.commonHorizontalSpacing),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppTextHeading(
                                  text: expenses[index].itemName,
                                  fontSize: 18,
                                ),
                                AppTextHeading(
                                  text: AppHelper.formatPKR(
                                    int.parse(
                                          expenses[index].unitPrice.toString(),
                                        ) *
                                        int.parse(
                                          expenses[index].itemQuantity
                                              .toString(),
                                        ),
                                  ),
                                  fontSize: 18,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            AppTextBody(
                              text: expenses[index].projectName,
                              fontSize: 14,
                            ),
                            SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                categoryContainer(context, expenses, index),
                                SizedBox(width: 12),
                                Flexible(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: context.appColors.secondary,
                                      ),
                                      SizedBox(width: 6),
                                      AppTextBody(
                                        fontSize: 14,
                                        text: AppHelper.formatDate(
                                          expenses[index].createdAt,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  Row(
                    children: [
                      AppUtils.expenseCard(
                        context,
                        "Returns",
                        expenses[index].returns,
                      ),
                      SizedBox(width: 12),
                      AppUtils.expenseCard(
                        context,
                        "Total",
                        expenses[index].itemQuantity,
                      ),
                      SizedBox(width: 12),
                      AppUtils.expenseCard(
                        context,
                        "Used",
                        expenses[index].usedItems,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) =>
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
    );
  }

  Container categoryContainer(
    BuildContext context,
    List<AddExpenseModel> expenses,
    int index,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: AppTextBody(
        text: expenses[index].category,
        color: context.appColors.primary,
        fontSize: 12,
      ),
    );
  }

  ListView projectList(MainLayoutDataController controller) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.projectsWithBudget.length,
      itemBuilder: (context, index) {
        final ProjectWithBudget projectWithBudget =
            controller.projectsWithBudget[index];

        final project = projectWithBudget.project;
        final allocatedAmount = projectWithBudget.allocatedAmount;

        final totalBudget = allocatedAmount?.amount.toInt() ?? 0;

        final int spentBudget = projectWithBudget.spent.toInt();
        final leftBudget = totalBudget - spentBudget;
        final double progressValue = AppHelper.calculatePercentage(
          spentBudget,
          totalBudget,
        );
        return AppCardWidget(
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
                  SizedBox(width: AppConstants.commonHorizontalSpacing),
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
                    text: '$progressValue%',
                    color: context.appColors.text,
                  ),
                ],
              ),
              SizedBox(height: AppConstants.commonVerticalSpacing / 4),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(12),
                value: progressValue / 100,
                minHeight: 6.5,
                backgroundColor: context.appColors.borderColor,
              ),
              SizedBox(height: AppConstants.commonVerticalSpacing / 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextBody(
                    text: "${AppHelper.formatPKR(spentBudget)} Spent",
                  ),
                  AppTextBody(
                    text: '${AppHelper.formatPKR(leftBudget)} Left',
                    color: context.appColors.colorGreen,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) =>
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
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
              AppTextBody(text: "Availaible Balance",),
            ],
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          AppTextHeading(text: AppHelper.formatPKR(availaibleBalance), fontSize: 28,  color: availaibleBalance < 0? context.appColors.error: context.appColors.text,),
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
