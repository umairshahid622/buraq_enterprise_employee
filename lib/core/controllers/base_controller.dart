// core/controllers/base_controller.dart
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  Future<T?> safeCall<T>(Future<T> Function() action) async {
    isLoading.value = true;
    update();
    try {
      return await action();
    } catch (e) {
      String error = AppHelper.getFirebaseErrorMessage(message: e.toString());
      print("error:::: $e");
      AppUtils.showToast(label: error, variant: ToastVariants.error);
      return null;
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
