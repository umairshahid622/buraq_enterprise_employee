import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/data/screens/add_expense_repository.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ManageExpenseScreenController extends BaseController {
  late AddExpenseModel expense;
  ManageExpenseScreenController({required this.expense});

  // data controllers

  //repositories
  final AddExpenseRepository _addExpenseRepository = AddExpenseRepository();

  //vairbales
  final List<String> tabs = ["Use Item", "Return Item"];
  int selectedIndex = 0;
  int previousIndex = 0;
  final RxInt _totalCost = 0.obs;
  // Use Item Fields
  final GlobalKey<FormState> useItemKey = GlobalKey<FormState>();
  late TextEditingController useQuanityController;

  // Return Item Fields
  final GlobalKey<FormState> returnItemKey = GlobalKey<FormState>();
  late TextEditingController returnQuanityController;
  late TextEditingController refundAmountController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }



  void _initializeControllers() {
    useQuanityController = TextEditingController();
    returnQuanityController = TextEditingController();
    refundAmountController = TextEditingController();
    returnQuanityController.addListener(_updateTotalCost);
    refundAmountController.addListener(_updateTotalCost);
  }

  void _updateTotalCost() {
    final qty = int.tryParse(returnQuanityController.text.trim()) ?? 0;
    final refund = int.tryParse(refundAmountController.text.trim()) ?? 0;
    _totalCost.value = qty * refund;
  }

  int get availaibleItems =>
      expense.itemQuantity - (expense.usedItems + expense.returns);

  void changeTab(int index) {
    previousIndex = selectedIndex;
    selectedIndex = index;
    update();
  }

  Future<bool> useItemSubmit()  async{
    if (!useItemKey.currentState!.validate()) return false;

    final (result, success) = await safeCall(
      () => _addExpenseRepository.updateUsedItems(
        expenseid: expense.expenseId,
        quantity: int.parse(useQuanityController.text.trim()),
      ),
    );
    return success;
  }

  void returnItemSubmit() {
    if (!returnItemKey.currentState!.validate()) return;
    print(returnQuanityController.text);
    print(refundAmountController.text);
    print(_totalCost.value);
  }

  int get totalCost => _totalCost.value;
}
