import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/home/expense_transaction_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ManageExpenseScreenWidget extends StatelessWidget {
  final AddExpenseModel expenseItem;
  const ManageExpenseScreenWidget({super.key, required this.expenseItem});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageExpenseScreenController>(
      init: ManageExpenseScreenController(expense: expenseItem),
      builder: (controller) {
        return Skeletonizer(
          enabled: controller.isLoading.value,
          child: tabBar(
            controller: controller,
            context: context,
            pages: [
              useItems(controller: controller, context: context),
              returnItem(controller: controller, context: context),
            ],
          ),
        );
      },
    );
  }

  Column tabBar({
    required ManageExpenseScreenController controller,
    required BuildContext context,
    required List<Widget> pages,
  }) {
    const double height = 37;
    const int duration = 250;
    const curve = Curves.easeInOut;

    return Column(
      children: [
        // ─── Tab Bar ───────────────────────────────────────
        AppCardWidget(
          verticalPadding: 5,
          horizontalPadding: 5,
          cardWidget: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / controller.tabs.length;
              return Stack(
                children: [
                  // ✅ Sliding indicator
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: controller.selectedIndex.toDouble(),
                      end: controller.selectedIndex.toDouble(),
                    ),
                    duration: const Duration(milliseconds: duration),
                    curve: curve,
                    builder: (context, value, _) {
                      return Positioned(
                        left: value * tabWidth,
                        child: Container(
                          width: tabWidth,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius / 1.5,
                            ),
                            color: context.appColors.primary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // ✅ Tab labels
                  Row(
                    children: List.generate(controller.tabs.length, (index) {
                      final isSelected = controller.selectedIndex == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              !isSelected ? controller.changeTab(index) : null,
                          child: Container(
                            height: height,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: AppTextHeading(
                              text: controller.tabs[index],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: AppConstants.commonVerticalSpacing),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: duration),
            transitionBuilder: (child, animation) {
              final isForward =
                  controller.selectedIndex > controller.previousIndex;
              final inOffset = isForward
                  ? const Offset(1, 0)
                  : const Offset(-1, 0);
              final outOffset = isForward
                  ? const Offset(-1, 0)
                  : const Offset(1, 0);
              final isIncoming =
                  child.key == ValueKey(controller.selectedIndex);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: isIncoming ? inOffset : outOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: curve)),
                child: child,
              );
            },
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.topCenter,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            ),
            child: KeyedSubtree(
              key: ValueKey(controller.selectedIndex),
              child: AppScrollableBody(child: pages[controller.selectedIndex]),
            ),
          ),
        ),
      ],
    );
  }

  Column useItems({
    required ManageExpenseScreenController controller,
    required BuildContext context,
  }) => Column(
    children: [
      AppCardWidget(cardWidget: expenseCard(controller)),
      SizedBox(height: AppConstants.commonVerticalSpacing),
      Form(
        key: controller.useItemKey,
        child: Column(
          children: [
            AppCardWidget(
              cardWidget: Column(
                children: [
                  AppTextField(
                    controller: controller.useQuanityController,
                    enabled: controller.availaibleItems != 0,
                    customValidator: (value) {
                      if (value!.isEmpty) {
                        return "Quantity to use cannot be empty";
                      }
                      if (int.tryParse(value) == 0) {
                        return "Quantity to use should be greater than 0";
                      }
                      if (int.parse(value) > controller.availaibleItems) {
                        return "Quantity to use should be less than ${controller.availaibleItems + 1}";
                      }
                      return null;
                    },
                    labelText: "Quantity to use",
                    type: TextFieldType.amount,
                    hintText: "Enter quanity to use",
                  ),
                ],
              ),
            ),
            SizedBox(height: AppConstants.commonVerticalSpacing),
            AppFilledButton(
              onPressedCallBack: () async {
                if (controller.availaibleItems == 0) {
                  AppUtils.showToast(
                    label: "No items to use",
                    variant: ToastVariants.error,
                  );
                  return;
                }
                final success = await controller.useItemSubmit();
                if (success) {
                  if (context.mounted) {
                    context.pop();
                  }
                }
                AppUtils.showToast(
                  label: success
                      ? "Item Used Saved Successfully"
                      : "Failed to save",
                  variant: success
                      ? ToastVariants.success
                      : ToastVariants.error,
                );
              },
              buttonText: "Save Used Quantity",
            ),
          ],
        ),
      ),
    ],
  );

  Column expenseCard(ManageExpenseScreenController controller) {
    double spacing = AppConstants.commonVerticalSpacing / 3;
    return Column(
      children: [
        expenseDetail(title: "Project", value: controller.expense.projectName),
        SizedBox(height: spacing),
        expenseDetail(title: "Item Name", value: controller.expense.itemName),
        SizedBox(height: spacing),
        expenseDetail(
          title:
              "Availaible to ${controller.selectedIndex == 0 ? 'Use' : 'Return'}",
          value: "${controller.availaibleItems} Units",
        ),
        SizedBox(height: spacing),
        expenseDetail(
          title:
              "Total ${controller.selectedIndex == 0 ? 'Used' : 'Returns'} Items",
          value:
              "${controller.selectedIndex == 0 ? controller.expense.usedItems : controller.expense.returns}",
        ),
        SizedBox(height: spacing),
        expenseDetail(
          title: "Unit Price",
          value: AppHelper.formatPKR(controller.expense.unitPrice),
        ),
      ],
    );
  }

  Row expenseDetail({String? title, String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextBody(text: title ?? ""),
        AppTextHeading(
          text: value ?? "",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Column returnItem({
    required ManageExpenseScreenController controller,
    required BuildContext context,
  }) => Column(
    children: [
      AppCardWidget(cardWidget: expenseCard(controller)),
      SizedBox(height: AppConstants.commonVerticalSpacing),
      Form(
        key: controller.returnItemKey,
        child: Column(
          children: [
            AppCardWidget(
              cardWidget: Column(
                children: [
                  AppTextField(
                    enabled: controller.availaibleItems != 0,
                    controller: controller.returnQuanityController,
                    labelText: "Quantity to Return",
                    type: TextFieldType.amount,
                    hintText: "Enter quanity to return",

                    customValidator: (value) {
                      if (value!.isEmpty) {
                        return "Quantity to return cannot be empty";
                      }
                      if (int.tryParse(value) == 0) {
                        return "Quantity to return should be greater than 0";
                      }
                      if (int.parse(value) > controller.availaibleItems) {
                        return "Quantity to return should be less than ${controller.availaibleItems + 1}";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppConstants.commonVerticalSpacing / 2),
                  AppUtils.totalCostContainer(
                    title: "Refundable Amount",
                    amount: () => controller.totalCost,
                    context: context,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppConstants.commonVerticalSpacing),
            AppFilledButton(
              isLoading: controller.isLoading.value,
              onPressedCallBack: () async {
                if (controller.availaibleItems == 0) {
                  AppUtils.showToast(
                    label: "No items to return",
                    variant: ToastVariants.error,
                  );
                  return;
                }
                final success = await controller.returnItemSubmit();
                if (success) {
                  if (context.mounted) {
                    context.pop();
                  }
                }
                AppUtils.showToast(
                  label: success
                      ? "Item Returned Successfully"
                      : "Failed to save return item",
                  variant: success
                      ? ToastVariants.success
                      : ToastVariants.error,
                );
              },
              buttonText: "Submit Return",
            ),
          ],
        ),
      ),
    ],
  );
}
