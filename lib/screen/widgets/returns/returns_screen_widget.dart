import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/returns/returns_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReturnsScreenWidget extends StatelessWidget {
  const ReturnsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReturnsScreenController>(
      init: ReturnsScreenController(),
      dispose: (controller) => Get.delete<ReturnsScreenController>(),
      builder: (controller) {
        return AppScrollableBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextHeading(text: "Availaible Itmes to Return"),
              SizedBox(height: AppConstants.commonVerticalSpacing),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.expenses.length,
                itemBuilder: (context, index) {
                  final AddExpenseModel expenseModel = controller.expenses[index];
                  return AppCardWidget(
                    cardWidget: Row(
                      children: [
                        AppUtils.iconContainer(
                          context: context,
                          icon: Icons.view_in_ar,
                        ),
                        SizedBox(width: AppConstants.commonHorizontalSpacing),
                        Flexible(child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextHeading(text: expenseModel.itemName, fontSize: 16),
                              AppTextHeading(text: "Returned: ${expenseModel.returns.toString()}", fontSize: 16, color: context.appColors.colorGreen,),                              
                            ],
                          )
                        ])),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppConstants.commonVerticalSpacing / 2),
              ),
            ],
          ),
        );
      },
    );
  }
}
