import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/home/view_all_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllScreen extends StatelessWidget {
  final bool isProject;
  final List<ProjectWithBudget>? projectWithBudget;
  final List<AddExpenseModel>? expenses;
  const ViewAllScreen({
    super.key,
    required this.isProject,
    this.projectWithBudget,
    this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewAllScreenController>(
      init: ViewAllScreenController(
        isProject: isProject,
        projectWithBudget: projectWithBudget,
        expenses: expenses,
      ),
      dispose: (controller) => Get.delete<ViewAllScreenController>(),
      builder: (controller) {
        return Column(
          children: [
            AppTextField(
              controller: controller.isProject
                  ? controller.projectSearchController
                  : controller.expenseSearchController,
              hintText: "Search ${isProject ? "Projects" : "Expenses"}",
              prefixIcon: Icon(Icons.search),
            ),

            Expanded(
              child: AppScrollableBody(
                child: Column(
                  children: [
                    SizedBox(height: AppConstants.commonVerticalSpacing),
                    isProject ? projectList(context: context,projects: controller.filteredProjects) : expenseList(context: context,expenses: controller.filteredExpenses)],
                ),
              ),
            ),
          ],
        );
      },
    );
  }  

  Widget projectList({required BuildContext context,List<ProjectWithBudget>? projects }) {
    return projects!.isEmpty
    ? Center(child: AppUtils.noDataFound(context: context, heading: "No projects found", subHeading: "No projects found"))
    : AppUtils.projectList(projects:projects);
  }

  Widget expenseList({required BuildContext context, List<AddExpenseModel>? expenses }) {
    return expenses!.isEmpty
    ? Center(child: AppUtils.noDataFound(context: context, heading: "No expenses found", subHeading: "No expenses found"))
    : AppUtils.expenseList(expenses: expenses);
  }
}
