import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/user_controller.dart';
import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  late final UserController _userController;

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
      return _userController.user ?? UserModel.empty();
    } catch (e) {
      Get.log('Error getting user: $e');
      return UserModel.empty();
    }
  }
}