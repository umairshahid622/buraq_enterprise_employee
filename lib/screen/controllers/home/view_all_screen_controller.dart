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

  @override
  void onInit() {
    super.onInit();
    projectSearchController.addListener(
      () => searchText.value = projectSearchController.text,
    );
    expenseSearchController.addListener(
      () => searchText.value = expenseSearchController.text,
    );
  }

  List<ProjectWithBudget> get filteredProjects {
    final query = searchText.value.toLowerCase().trim();
    return (projectWithBudget ?? []).where((p) {
      final name = p.project.projectName.toLowerCase();
      final code = p.project.projectId.toLowerCase();
      return name.contains(query) || code.contains(query);
    }).toList();
  }

  List<AddExpenseModel> get filteredExpenses {
    final query = searchText.value.toLowerCase().trim();
    return (expenses ?? []).where((e) {
      final category = e.category.toLowerCase();
      final name = e.itemName.toLowerCase();
      return category.contains(query) || name.contains(query);
    }).toList();
  }

  @override
  void onClose() {
    projectSearchController.dispose();
    expenseSearchController.dispose();
    super.onClose();
  }
}
