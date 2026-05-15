import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:flutter/widgets.dart';

class ManageExpenseScreenController extends BaseController {
  late AddExpenseModel expense;
  ManageExpenseScreenController({required this.expense});
  
  final List<String> tabs = ["Use Item", "Return Item"];
  int selectedIndex = 0;
  int previousIndex = 0;

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
  }

  
  int get availaibleItems => expense.itemQuantity - (expense.usedItems + expense.returns);

  void changeTab(int index) {
    previousIndex = selectedIndex;
    selectedIndex = index;
    update();
  }

  void useItemSubmit(){
    if (!useItemKey.currentState!.validate()) return; 
    print(useQuanityController.text);
  }

  void returnItemSubmit(){
    if (!returnItemKey.currentState!.validate()) return; 
    print(returnQuanityController.text);
    print(refundAmountController.text);
  }
}
