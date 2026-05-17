
import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final phoneNumberController = TextEditingController();
  final RxBool otpLoading = false.obs;
  final RxBool verifyNumberLoading = false.obs;


  String? _verificationId;
  String? get verificationId => _verificationId;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  int otpLength = 6;

  late final List<TextEditingController> otpControllers = List.generate(
    otpLength,
    (index) => TextEditingController(),
  );

  late final List<FocusNode> otpFocusNodes = List.generate(
    otpLength,
    (index) => FocusNode(),
  );

  String get completeOtp => otpControllers.map((e) => e.text).join();

  Future<void> verifyPhoneNumber(Function(String verId)? onCodeSent) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    verifyNumberLoading.value = true;
    await safeCall(
      () => AuthRepository().verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        onCodeSent: (verId) {
          _verificationId = verId;
          onCodeSent?.call(verId);
        },
      ),
    );
    verifyNumberLoading.value = false;
  }

  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) return;
    if (verificationId == null || completeOtp.length != otpLength) return;
    otpLoading.value = true;
    final (credential, success) = await safeCall(
      () => AuthRepository().signInWithOtp(verificationId!, completeOtp),      
    );
    otpLoading.value = false;
    if (credential != null && success) {
      final userController = Get.find<UserController>();
      await userController.fetchUserProfile();
    }
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    for (var node in otpFocusNodes) {
      node.unfocus();
    }
  }

  @override
  void onClose() {
    phoneNumberController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
