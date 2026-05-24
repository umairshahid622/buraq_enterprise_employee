import 'package:buraq_enterprise_employee/core/config/colors/app_color_scheme.dart';
import 'package:buraq_enterprise_employee/core/config/colors/app_colors.dart';
import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';

class AppUtils {
  static Container getNameInitalsContainer({
    required String firstName,
    required String lastName,
    required AppColorScheme colorScheme,
    double size = 75.0,
  }) {
    final String firstNameInitial = AppHelper.getInitials(
      firstName,
    ).toUpperCase();
    final String lastNameInitial = AppHelper.getInitials(
      lastName,
    ).toUpperCase();
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
      ),
      child: AppTextHeading(
        text: "$firstNameInitial$lastNameInitial",
        fontSize: size / 2,
        color: AppColors.darkBorderColor,
      ),
    );
  }

  static void showToast({
    required String label,
    required ToastVariants variant,
  }) {
    final scaffoldState = AppConstants.scaffoldMessengerKey.currentState;
    if (scaffoldState == null || !scaffoldState.mounted) return;
    final context = scaffoldState.context;
    final Color backgroundColor;
    switch (variant) {
      case ToastVariants.success:
        backgroundColor = context.appColors.colorGreen;
        break;
      case ToastVariants.error:
        backgroundColor = context.appColors.error;
        break;
    }

    scaffoldState.showSnackBar(
      SnackBar(
        content: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        width: 280.0,
        duration: const Duration(seconds: 4),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
    );
  }

  static Container statusContainer({
    required BuildContext context,
    required String status,
    double? fontSize,
    AppColorScheme? colorScheme,
  }) {
    final colors = colorScheme ?? context.appColors;
    final Color bgColor;
    final Color textColor;
    if (status == Status.active.name) {
      bgColor = colors.colorGreen.withValues(alpha: 0.20);
      textColor = colors.colorGreen;
    } else if (status == Status.inactive.name) {
      bgColor = colors.error.withValues(alpha: 0.20);
      textColor = colors.error;
    } else if (status == Status.completed.name) {
      bgColor = colors.primary.withValues(alpha: 0.20);
      textColor = colors.primary;
    } else {
      bgColor = colors.secondary.withValues(alpha: 0.20);
      textColor = colors.secondary;
    }
    if (status.isEmpty) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: textColor, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Center(
        child: AppTextBody(text: status, color: textColor, fontSize: fontSize),
      ),
    );
  }

  static Expanded expenseCard(
    BuildContext context,
    String expenseType,
    int amount, {
    bool isMoney = false,
    AppColorScheme? colorScheme,
  }) {
    final colors = colorScheme ?? context.appColors;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: colors.chipColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextHeading(
              text: expenseType,
              fontSize: 14,
              color: colors.secondary,
            ),
            SizedBox(height: 5),
            AppTextHeading(
              text: isMoney ? AppHelper.formatPKR(amount) : amount.toString(),
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  static Widget noDataFound({
    required BuildContext context,
    required String heading,
    required String subHeading,
  }) {
    return Center(
      heightFactor: 3.5,
      child: Column(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: context.appColors.primary,
            size: 80,
          ),
          AppTextHeading(
            text: heading,
            textAlign: TextAlign.center,
            fontSize: 18,
          ),
          SizedBox(height: 2),
          AppTextBody(text: subHeading),
        ],
      ),
    );
  }

  static Widget noSearchFound({
    required BuildContext context,
    required String heading,
  }) {
    return Center(
      heightFactor: 3.5,
      child: Column(
        children: [
          Icon(
            Icons.search_rounded,
            color: context.appColors.primary,
            size: 80,
          ),
          AppTextHeading(
            text: heading,
            textAlign: TextAlign.center,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  static Divider divider({
    required AppColorScheme colorScheme,
    double thickness = 1.0,
  }) {
    return Divider(color: colorScheme.secondary, thickness: thickness);
  }

  static Container rsContainer({required BuildContext context}) {
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppTextBody(text: "Rs", fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  static Container iconContainer({
    required BuildContext context,
    required IconData icon,
  }) {
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: context.appColors.colorBlue, size: 30),
    );
  }

  static Container totalCostContainer({
    required int Function() amount,
    required BuildContext context,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.03),
        border: Border.all(color: context.appColors.primary),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextBody(text: title),
          Obx(
            () => AppTextHeading(
              text: AppHelper.formatPKR(amount()),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  static ListView projectList({
    required List<ProjectWithBudget> projects,
    int? projectLength,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: projectLength != null
          ? projectLength.clamp(0, projects.length)
          : projects.length,
      itemBuilder: (context, index) {
        final ProjectWithBudget projectWithBudget = projects[index];

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: AppTextHeading(
                      text: project.projectName,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: AppConstants.commonHorizontalSpacing),
                  statusContainer(context: context, status: project.status),
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

  static Container categoryContainer(
    BuildContext context,
    List<AddExpenseModel> expenses,
    int index,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: AppTextBody(
        text: expenses[index].category,
        color: context.appColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }

  static ListView expenseList({
    required List<AddExpenseModel> expenses,
    int? expenseLength,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenseLength != null
          ? expenseLength.clamp(0, expenses.length)
          : expenses.length,
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
                      rsContainer(context: context),
                      SizedBox(width: AppConstants.commonHorizontalSpacing),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AppTextHeading(
                                    text:
                                        "${expenses[index].itemName} (${expenses[index].itemQuantity})",
                                    fontSize: 18,
                                  ),
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
                      expenseCard(context, "Returns", expenses[index].returns),
                      SizedBox(width: 12),
                      expenseCard(
                        context,
                        "Available",
                        expenses[index].itemQuantity -
                            expenses[index].usedItems -
                            expenses[index].returns,
                      ),
                      SizedBox(width: 12),
                      expenseCard(context, "Used", expenses[index].usedItems),
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

  static Future<void> appDialog({
    required BuildContext context,
    required Function() onSubmitCallBack,
    Function()? onCancelCallBack,
    required bool Function() isLoading,
    bool barrierDismissible = true,

    required IconData icon,
    required String title,
    required String message,
    required String subMessage,
    required String submitButtonText,
    String? cancelButtonText,
  }) async {
    await showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppConstants.padding + 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.padding,
              vertical: AppConstants.padding * 2,
            ),
            decoration: BoxDecoration(
              color: dialogContext.appColors.background,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.appColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: context.appColors.chipColor,
                    size: 42,
                  ),
                ),
                SizedBox(height: AppConstants.commonVerticalSpacing),
                AppTextHeading(text: title, fontSize: 24),
                SizedBox(height: AppConstants.commonVerticalSpacing),
                AppTextBody(
                  text: message,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                if (subMessage.isNotEmpty) ...[
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  AppTextBody(
                    text: subMessage,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: AppConstants.commonVerticalSpacing),
                Row(
                  children: [
                    if (onCancelCallBack != null) ...[
                      Expanded(
                        child: AppFilledButton(
                          onPressedCallBack: onCancelCallBack,
                          buttonText: cancelButtonText ?? "Cancel",
                          backgroundeColor: context.appColors.secondary,
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Obx(
                        () => AppFilledButton(
                          isLoading: isLoading(),
                          onPressedCallBack: onSubmitCallBack,
                          buttonText: submitButtonText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
