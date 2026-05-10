import 'package:buraq_enterprise_employee/core/bindings/initial_bindings.dart';
import 'package:buraq_enterprise_employee/core/config/app_router.dart';
import 'package:buraq_enterprise_employee/core/config/colors/app_theme.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/firebase_options.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/theme_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    String error = AppHelper.getFirebaseErrorMessage(message: e.toString());
    AppUtils.showToast(label: error,vairant: ToastVariants.error);
  }
  await GetStorage.init();
  InitialBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Buraq Enterprise",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      scaffoldMessengerKey: AppConstants.scaffoldMessengerKey,
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      backButtonDispatcher: appRouter.backButtonDispatcher,
    );
  }
}