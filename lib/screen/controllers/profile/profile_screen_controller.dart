import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  late final UserController _userController;
  RxBool isLogoutProcessing = false.obs;

    //Todo:  Remove try catch block and Call the method from Base Controller

  @override
  void onInit() {
    super.onInit();
    try {
      _userController = Get.find<UserController>();
    } catch (e) {
      Get.log('UserController not found: $e');
    }
  }

  UserModel get user {
    try {
      return _userController.userRx.value  ?? UserModel.empty();
    } catch (e) {
      Get.log('Error getting user: $e');
      return UserModel.empty();
    }
  }

  Future<void> logout() async{
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


}