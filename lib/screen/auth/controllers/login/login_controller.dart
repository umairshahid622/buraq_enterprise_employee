import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final AuthRepository _authRepository = AuthRepository();

  //Text Editing Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // variables

  RxBool obscureText = true.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    final (userCred, success) = await safeCall(
      () => _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    if (userCred != null && success) {
      final userController = Get.find<UserController>();
      await userController.fetchUserProfile();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
