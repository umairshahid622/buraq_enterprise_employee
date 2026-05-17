import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/main_layout_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  late final UserController _userController;
  late final MainLayoutDataController _mainLayoutController;
  Worker? _dataWorker;
  RxBool isLogoutProcessing = false.obs;

  //Todo:  Remove try catch block and Call the method from Base Controller

  @override
  void onInit() {
    super.onInit();
    try {
      _userController = Get.find<UserController>();
      _mainLayoutController = Get.find<MainLayoutDataController>();
      _dataWorker = ever<bool>(_mainLayoutController.isLoading, (_) {
        update();
      });
    } catch (e) {
      Get.log('Profile dependency not found: $e');
    }
  }

  UserModel get user {
    try {
      return _userController.userRx.value ?? UserModel.empty();
    } catch (e) {
      Get.log('Error getting user: $e');
      return UserModel.empty();
    }
  }

  int get activeProjectCount {
    return _mainLayoutController.projectsWithBudget
        .where((project) => project.project.status == Status.active.name)
        .length;
  }

  int get totalProjectCount => _mainLayoutController.projectsWithBudget.length;

  int get completedProjectCount {
    return _mainLayoutController.projectsWithBudget
        .where((project) => project.project.status == Status.completed.name)
        .length;
  }

  int get expenseCount => _mainLayoutController.expenses.length;

  double get allocatedAmount => _mainLayoutController.allocatedAmount;

  double get spentAmount => _mainLayoutController.spentAmount;

  double get availableAmount => allocatedAmount - spentAmount;

  String get activeProjectsLabel {
    final label = activeProjectCount == 1
        ? "Active Project"
        : "Active Projects";
    return "$activeProjectCount $label";
  }

  Future<void> logout() async {
    isLogoutProcessing.value = true;
    try {
      await _userController.signOut();
    } catch (e) {
      String error = AppHelper.getFirebaseErrorMessage(message: e.toString());
      AppUtils.showToast(label: error, variant: ToastVariants.error);
    } finally {
      isLogoutProcessing.value = false;
    }
  }

  @override
  void onClose() {
    _dataWorker?.dispose();
    super.onClose();
  }
}
