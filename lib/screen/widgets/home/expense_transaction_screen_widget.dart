import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/home/expense_transaction_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ExpenseTransactionScreenWidget extends StatelessWidget {
  final AddExpenseModel expense;
  const ExpenseTransactionScreenWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseTransactionScreenController>(
      init: ExpenseTransactionScreenController(),
      builder: (controller) {
        return AppScrollableBody(
          child: Column(
            children: [
              tabBar(
                controller: controller,
                context: context,
                selectedIndex: controller.selectedIndex,
                tabs: controller.tabs,
                pages: [useItems(), returnItem()],
              ),
            ],
          ),
        );
      },
    );
  }

  AppTextHeading returnItem() => AppTextHeading(text: "Return Items");

  AppTextHeading useItems() => AppTextHeading(text: "Used Items");

  Column tabBar({
    required ExpenseTransactionScreenController controller,
    required BuildContext context,
    required int selectedIndex,
    required List<Widget> pages,
    required List<String> tabs,
  }) {
    return Column(
      children: [
        AppCardWidget(
          verticalPadding: 5,
          horizontalPadding: 5,
          cardWidget: Row(
            children: List.generate(tabs.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius / 1.5,
                      ),
                      color: selectedIndex == index
                          ? context.appColors.primary.withValues(alpha: 0.5)
                          : null,
                    ),
                    child: AppTextHeading(text: tabs[index], fontSize: 16),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: AppConstants.commonVerticalSpacing),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final isForward =
                controller.selectedIndex > controller.previousIndex;
            final offset = isForward ? const Offset(1, 0) : const Offset(-1, 0);
            return SlideTransition(
              position: Tween<Offset>(
                begin: offset,
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: KeyedSubtree(
            key: ValueKey(selectedIndex),
            child: pages[selectedIndex],
          ),
        ),
      ],
    );
  }
}
