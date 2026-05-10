
import 'package:buraq_enterprise_employee/core/controllers/theme_controller.dart';
import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:buraq_enterprise_employee/screen/controllers/splash/splash_screen_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);

    Get.put<UserController>(UserController(), permanent: true);

    Get.put<SplashController>(SplashController(), permanent: true);
  }
}
