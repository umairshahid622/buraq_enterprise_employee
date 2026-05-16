import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:flutter/material.dart';

class ViewAllScreen extends StatelessWidget {
  final bool isProject;
  final List<ProjectWithBudget> projectWithBudget;
  final List<AddExpenseModel> expenses;
  const ViewAllScreen({super.key, required this.isProject, required this.projectWithBudget, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}