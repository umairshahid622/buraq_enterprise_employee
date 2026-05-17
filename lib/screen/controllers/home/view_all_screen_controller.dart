

import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ViewAllScreenController extends BaseController {
  final bool isProject;
  final List<ProjectWithBudget>? projectWithBudget;
  final List<AddExpenseModel>? expenses;

  ViewAllScreenController({
    required this.isProject,
    this.projectWithBudget,
    this.expenses,
  });

  TextEditingController projectSearchController = TextEditingController();
  TextEditingController expenseSearchController = TextEditingController();
  RxString searchText = "".obs;

  List<ProjectWithBudget> get filteredProjects {
  final query = searchText.value.toLowerCase();
  return projectWithBudget!.where((p) {
    final name = p.project.projectName.toLowerCase();
    final code = p.project.projectId.toLowerCase();
    return name.contains(query) || code.contains(query);
  }).toList();
}

List<AddExpenseModel> get filteredExpenses {
  final query = searchText.value.toLowerCase();
  return expenses!.where((e) {
    final category = e.category.toLowerCase();
    final name = e.itemName.toLowerCase();
    return category.contains(query) || name.contains(query);
  }).toList();
}


  
  
}