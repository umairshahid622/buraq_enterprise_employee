import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/main_layout_controller.dart';
import 'package:get/get.dart';

class ReturnsScreenController extends BaseController {
  late MainLayoutDataController _mainLayoutController;
  @override
  void onInit() {
    super.onInit();
    _mainLayoutController = Get.find<MainLayoutDataController>();    
  }


  List<AddExpenseModel> get expenses => _mainLayoutController.expenses;  
  
}