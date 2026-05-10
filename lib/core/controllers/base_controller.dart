// core/controllers/base_controller.dart
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class BaseController extends GetxController {
  Future<T?> safeCall<T>(
    Future<T> Function() action, {
    VoidCallback? onStart,
    VoidCallback? onComplete,
  }) async {
    onStart?.call();
    try {
      return await action();
    } catch (e) {
      String error = AppHelper.getFirebaseErrorMessage(message: e.toString());
      AppUtils.showToast(label: error, variant: ToastVariants.error);
      return null;
      
    } finally {
      onComplete?.call();
    }
  }
}
