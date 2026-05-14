import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/home/expense_transaction_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ManageExpenseScreenWidget extends StatelessWidget {
  final AddExpenseModel expense;
  const ManageExpenseScreenWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageExpenseScreenController>(
      init: ManageExpenseScreenController(),
      builder: (controller) {
        return AppScrollableBody(
          child: Column(
            children: [
              tabBar(
                controller: controller,
                context: context,
                pages: [useItems(), returnItem()],
              ),
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
    return Column(
      children: [
        AppCardWidget(
          verticalPadding: 5,
          horizontalPadding: 5,
          cardWidget: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / controller.tabs.length;
              return Stack(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: controller.selectedIndex.toDouble(),
                      end: controller.selectedIndex.toDouble(),
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
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
            key: ValueKey(controller.selectedIndex),
            child: pages[controller.selectedIndex],
          ),
        ),
      ],
    );
  }

  AppTextHeading returnItem() => AppTextHeading(text: "Return Items");

  AppTextHeading useItems() => AppTextHeading(text: "Used Items");
}
