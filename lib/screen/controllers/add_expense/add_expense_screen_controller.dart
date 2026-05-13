import 'dart:io';

import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/data/screens/add_expense_repository.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/main_layout_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/classes/app_dropdown_button_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddExpenseScreenController extends BaseController {
  late final MainLayoutDataController _dataController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _dataController =
        Get.find<MainLayoutDataController>();
  }

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();

  final AddExpenseRepository _addExpenseRepository = AddExpenseRepository();

  RxInt totalCost = 0.obs;

  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

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
    final permission = await Permission.camera.request();
    if (permission.isDenied) {
      AppUtils.showToast(
        label: 'Camera permission is required',
        variant: ToastVariants.error,
      );
      return;
    }

    if (permission.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile == null) return;
    selectedImage.value = File(pickedFile.path);
    update();
  }

  Future<void> addExpense() async {
    if (!formKey.currentState!.validate()) return;
    await safeCall(
      () => _addExpenseRepository.addExpense(
        itemName: itemNameController.text.trim(),
        itemQuantity: int.parse(itemQuantityController.text.trim()),
        unitPrice: int.parse(unitPriceController.text.trim()),
        additionalNotes: additionalNotesController.text.trim(),
        employeeId: _dataController.user!.empId,
        projectId: projectNotifier.value!.projectId,
        projectName: projectNotifier.value!.projectName,
        receipt: selectedImage.value!,
      ),
    );
    onSucessExpenseAdded();
  }

  void onSucessExpenseAdded() {
    clearValues();
    AppUtils.showToast(
      label: "Expense Added Successfully",
      variant: ToastVariants.success,
    );
  }

  void clearValues() {
    projectNotifier.value = null;
    categoryNotifier.value = null;
    // controlllers
    itemNameController.clear();
    itemQuantityController.clear();
    unitPriceController.clear();
    additionalNotesController.clear();
    totalCost.value = 0;
    removeImage();

    formKey.currentState?.reset();
  }

  removeImage() {
    selectedImage.value = null;
    update();
  }

  List<ProjectModel> get projects=>_dataController.projects;



  @override
  void dispose() {
    super.dispose();
    projectNotifier.dispose();
    categoryNotifier.dispose();
    clearValues();
  }
}
