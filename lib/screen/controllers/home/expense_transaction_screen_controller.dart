import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/main_layout_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class ManageExpenseScreenController extends BaseController {
  late MainLayoutDataController _mainLayoutDataController;

  @override
  void onInit() {
    super.onInit();
    _mainLayoutDataController = Get.find<MainLayoutDataController>();
  }

  final List<String> tabs = ["Use Item", "Return Item"];
  int selectedIndex = 0;
  int previousIndex = 0;

  void changeTab(int index) {
    selectedIndex = index;
    update();
  }
}
