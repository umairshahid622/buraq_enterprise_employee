import 'dart:io';

import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/project_controller.dart';
import 'package:buraq_enterprise_employee/utils/classes/app_dropdown_button_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddExpenseScreenController extends ProjectController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();

  RxInt totalCost = 0.obs;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  final ValueNotifier<ProjectModel?> projectNotifier = ValueNotifier(null);
  final ValueNotifier<String?> categoryNotifier = ValueNotifier(null);
      

  List<AppDropdownButtonClass> categoryDropdownItems = [
    AppDropdownButtonClass(label: "Materials", id: "Materials"),
    AppDropdownButtonClass(label: "Travel", id: "Travel"),
    AppDropdownButtonClass(label: "Tools", id: "Tools"),
    AppDropdownButtonClass(label: "Meals", id: "Meals"),
    AppDropdownButtonClass(label: "Other", id: "Other"),
  ];

  set selectedProject(ProjectModel? projectId) {
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

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source, // This determines if Camera or Gallery opens
      imageQuality: 80,
    );

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
    }
  }

  removeImage() {
    selectedImage = null;
    update();
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
