import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/my_stats/my_stats_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyStatsScreenWidget extends StatelessWidget {
  const MyStatsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyStatsScreenController>(
      init: MyStatsScreenController(),
      dispose: (controller) => Get.delete<MyStatsScreenController>(),
      builder: (controller) {
        final isLoading = controller.isStatsLoading;

        if (!isLoading && !controller.hasData) {
          return RefreshIndicator(
            onRefresh: controller.refreshStats,
            child: AppScrollableBody(
              centerContent: true,
              child: AppUtils.noDataFound(
                context: context,
                heading: "No stats available",
                subHeading:
                    "Your stats will appear after projects or expenses are added",
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshStats,
          child: Skeletonizer(
            enabled: isLoading,
            child: AppScrollableBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  budgetOverview(context, controller),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  metricGrid(context, controller),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  sectionHeading("Project Performance"),
                  SizedBox(height: AppConstants.commonVerticalSpacing / 2),
                  projectPerformanceList(context, controller),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  sectionHeading("Category Breakdown"),
                  SizedBox(height: AppConstants.commonVerticalSpacing / 2),
                  categoryBreakdown(context, controller),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  sectionHeading("Recent Activity"),
                  SizedBox(height: AppConstants.commonVerticalSpacing / 2),
                  recentActivityList(context, controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppCardWidget budgetOverview(
    BuildContext context,
    MyStatsScreenController controller,
  ) {
    final progress = controller.budgetUsedPercentage;
    final availableAmount = controller.availableAmount;

    return AppCardWidget(
      verticalPadding: AppConstants.padding,
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextHeading(text: "Budget Overview", fontSize: 18),
              AppTextBody(
                text: "${progress.toStringAsFixed(1)}%",
                color: context.appColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          AppTextBody(text: "Available Balance"),
          SizedBox(height: 4),
          AppTextHeading(
            text: AppHelper.formatPKR(availableAmount),
            fontSize: 28,
            color: availableAmount < 0
                ? context.appColors.error
                : context.appColors.text,
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 10,
              backgroundColor: context.appColors.borderColor,
              color: availableAmount < 0
                  ? context.appColors.error
                  : context.appColors.primary,
            ),
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          Row(
            children: [
              Flexible(
                child: amountPair(
                  context,
                  "Allocated",
                  controller.allocatedAmount,
                  context.appColors.colorBlue,
                ),
              ),
              SizedBox(width: AppConstants.commonHorizontalSpacing),
              Flexible(
                child: amountPair(
                  context,
                  "Spent",
                  controller.spentAmount,
                  context.appColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget amountPair(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextBody(text: label, color: context.appColors.secondary),
        SizedBox(height: 4),
        AppTextHeading(
          text: AppHelper.formatPKR(amount),
          color: color,
          fontSize: 16,
        ),
      ],
    );
  }

  Widget metricGrid(BuildContext context, MyStatsScreenController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - AppConstants.commonHorizontalSpacing) / 2;

        return Wrap(
          spacing: AppConstants.commonHorizontalSpacing,
          runSpacing: AppConstants.commonVerticalSpacing / 2,
          children: [
            metricTile(
              context,
              width: itemWidth,
              icon: Icons.work_outline,
              label: "Projects",
              value: controller.projectCount.toString(),
              color: context.appColors.colorBlue,
            ),
            metricTile(
              context,
              width: itemWidth,
              icon: Icons.receipt_long_outlined,
              label: "Expenses",
              value: controller.expenseCount.toString(),
              color: context.appColors.primary,
            ),
            metricTile(
              context,
              width: itemWidth,
              icon: Icons.payments_outlined,
              label: "Avg Expense",
              value: AppHelper.formatPKR(controller.averageExpenseAmount),
              color: context.appColors.colorGreen,
            ),
            metricTile(
              context,
              width: itemWidth,
              icon: Icons.category_outlined,
              label: "Top Category",
              value: controller.topCategory?.category ?? "None",
              color: context.appColors.secondary,
            ),
          ],
        );
      },
    );
  }

  Widget metricTile(
    BuildContext context, {
    required double width,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: width,
      child: AppCardWidget(
        verticalPadding: AppConstants.padding,
        cardWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: AppConstants.commonVerticalSpacing / 2),
            AppTextBody(text: label, color: context.appColors.secondary),
            SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: AppTextHeading(text: value, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppTextHeading sectionHeading(String text) {
    return AppTextHeading(text: text, fontSize: 16);
  }

  Widget projectPerformanceList(
    BuildContext context,
    MyStatsScreenController controller,
  ) {
    final projects = controller.isStatsLoading
        ? skeletonProjects
        : controller.projectsBySpend;

    if (projects.isEmpty) {
      return emptyCard(context, "No project spending yet");
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, index) =>
          projectPerformanceCard(context, projects[index]),
      separatorBuilder: (context, index) =>
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
    );
  }

  Widget projectPerformanceCard(
    BuildContext context,
    ProjectWithBudget projectWithBudget,
  ) {
    final allocated = projectWithBudget.allocated;
    final spent = projectWithBudget.spent;
    final progress = AppHelper.calculatePercentage(
      spent.toInt(),
      allocated.toInt(),
    );

    return AppCardWidget(
      verticalPadding: AppConstants.padding,
      cardWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AppTextHeading(
                  text: projectWithBudget.project.projectName,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: AppConstants.commonHorizontalSpacing),
              AppTextBody(
                text: "${progress.toStringAsFixed(1)}%",
                color: context.appColors.primary,
              ),
            ],
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 7,
              backgroundColor: context.appColors.borderColor,
              color: context.appColors.primary,
            ),
          ),
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextBody(text: "${AppHelper.formatPKR(spent)} spent"),
              AppTextBody(
                text: "${AppHelper.formatPKR(allocated)} allocated",
                color: context.appColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget categoryBreakdown(
    BuildContext context,
    MyStatsScreenController controller,
  ) {
    final categories = controller.isStatsLoading
        ? skeletonCategories
        : controller.categorySpends;

    if (categories.isEmpty) {
      return emptyCard(context, "No categories to show");
    }

    final maxAmount = categories.first.amount <= 0
        ? 1
        : categories.first.amount;

    return AppCardWidget(
      verticalPadding: AppConstants.padding,
      cardWidget: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final progress = (category.amount / maxAmount).clamp(0.0, 1.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AppTextHeading(
                      text: category.category,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: AppConstants.commonHorizontalSpacing),
                  AppTextBody(
                    text: AppHelper.formatPKR(category.amount),
                    color: context.appColors.secondary,
                  ),
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,
                  backgroundColor: context.appColors.borderColor,
                  color: categoryColor(context, index),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(height: AppConstants.commonVerticalSpacing / 2),
      ),
    );
  }

  Widget recentActivityList(
    BuildContext context,
    MyStatsScreenController controller,
  ) {
    final expenses = controller.isStatsLoading
        ? skeletonExpenses
        : controller.recentExpenses;

    if (expenses.isEmpty) {
      return emptyCard(context, "No recent expenses");
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) =>
          recentExpenseCard(context, expenses[index]),
      separatorBuilder: (context, index) =>
          SizedBox(height: AppConstants.commonVerticalSpacing / 2),
    );
  }

  Widget recentExpenseCard(BuildContext context, AddExpenseModel expense) {
    final quantityAfterReturns = expense.itemQuantity - expense.returns;
    final amount = expense.unitPrice * quantityAfterReturns.clamp(0, 1 << 31);

    return AppCardWidget(
      verticalPadding: AppConstants.padding,
      cardWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppUtils.rsContainer(context: context),
          SizedBox(width: AppConstants.commonHorizontalSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: AppTextHeading(
                        text: expense.itemName,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: AppConstants.commonHorizontalSpacing),
                    AppTextHeading(
                      text: AppHelper.formatPKR(amount),
                      fontSize: 16,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                AppTextBody(text: expense.projectName),
                SizedBox(height: 4),
                AppTextBody(
                  text: AppHelper.formatDate(expense.createdAt),
                  color: context.appColors.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyCard(BuildContext context, String text) {
    return AppCardWidget(
      verticalPadding: AppConstants.padding,
      cardWidget: Center(
        child: AppTextBody(text: text, color: context.appColors.secondary),
      ),
    );
  }

  Color categoryColor(BuildContext context, int index) {
    final colors = [
      context.appColors.primary,
      context.appColors.colorBlue,
      context.appColors.colorGreen,
      context.appColors.secondary,
    ];
    return colors[index % colors.length];
  }

  List<ProjectWithBudget> get skeletonProjects => [
    ProjectWithBudget(project: skeletonProject("Project Alpha"), expenses: []),
    ProjectWithBudget(project: skeletonProject("Project Beta"), expenses: []),
    ProjectWithBudget(project: skeletonProject("Project Gamma"), expenses: []),
  ];

  List<CategorySpend> get skeletonCategories => const [
    CategorySpend(category: "Materials", amount: 80000),
    CategorySpend(category: "Transport", amount: 45000),
    CategorySpend(category: "Labor", amount: 30000),
  ];

  List<AddExpenseModel> get skeletonExpenses => [
    skeletonExpense("Cement Bags", "Project Alpha"),
    skeletonExpense("Steel Rods", "Project Beta"),
    skeletonExpense("Transport", "Project Gamma"),
  ];

  ProjectModel skeletonProject(String name) {
    return ProjectModel(
      projectId: "project-id",
      projectName: name,
      projectDiscription: "",
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      totalBudgetAllocated: 100000,
      remainingBudget: 40000,
      status: "active",
      createdBy: "",
      updatedBy: "",
    );
  }

  AddExpenseModel skeletonExpense(String itemName, String projectName) {
    return AddExpenseModel(
      expenseId: "expense-id",
      itemName: itemName,
      itemQuantity: 10,
      usedItems: 0,
      unitPrice: 2500,
      additionalNotes: "",
      employeeId: "employee-id",
      returns: 0,
      projectId: "project-id",
      category: "Materials",
      projectName: projectName,
      receiptUrl: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: "",
      updatedBy: "",
    );
  }
}
