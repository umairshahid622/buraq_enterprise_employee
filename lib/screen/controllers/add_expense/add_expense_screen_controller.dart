import 'package:buraq_enterprise_employee/screen/controllers/common/project_controller.dart';
import 'package:buraq_enterprise_employee/utils/classes/app_dropdown_button_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreenController extends ProjectController {

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();

  RxInt totalCost = 0.obs;



  final ValueNotifier<String?> projectNotifier = ValueNotifier(null);
  final ValueNotifier<String?> categoryNotifier = ValueNotifier(null);

  List<AppDropdownButtonClass> get projectDropdownItems => projects
      .map((p) => AppDropdownButtonClass(label: p.projectName, id: p.projectId))
      .toList();

  List<AppDropdownButtonClass> categoryDropdownItems = [
    AppDropdownButtonClass(label: "Materials", id: "Materials"),
    AppDropdownButtonClass(label: "Travel", id: "Travel"),
    AppDropdownButtonClass(label: "Tools", id: "Tools"),
    AppDropdownButtonClass(label: "Meals", id: "Meals"),
    AppDropdownButtonClass(label: "Other", id: "Other"),
  ];

  set selectedProject(String? projectId) {
    projectNotifier.value = projectId;
  }

  set selectedCategory(String? categoryName) {
    categoryNotifier.value = categoryName;
  }


  calculateTotalCost() {
    int quantity = int.tryParse(itemQuantityController.text) ?? 0;
    int unitPrice = int.tryParse(unitPriceController.text) ?? 0;
    totalCost.value = quantity * unitPrice;
  }

  @override
  void dispose() {   
    super.dispose();
    projectNotifier.dispose();
    categoryNotifier.dispose();

    // controlllers
    itemNameController.dispose();
    itemQuantityController.dispose();
    unitPriceController.dispose();    
    additionalNotesController.dispose();
  }

}
