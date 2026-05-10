
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/user_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneNumberController = TextEditingController();
  final RxBool loading = false.obs;
  final RxBool otpLoading = false.obs;

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
    loading.value = true;
    print("Verify Phone Number Called with: ${phoneNumberController.text}"); // Debug print
    try {
      await AuthRepository().verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        onCodeSent: (verId) {
          _verificationId = verId;
          loading.value = false;
          onCodeSent?.call(verId);
        },        
      );
    } catch (e) {
      loading.value = false;
      String error = AppHelper.getFirebaseErrorMessage(message: e.toString());
      print(error); // Debug print
      AppUtils.showToast(
        label: error,
        vairant: ToastVariants.error,
      );
    }
  }

  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) {
      return;
    }

    if (verificationId == null || completeOtp.length != otpLength) {
      return;
    }
    otpLoading.value = true;
    try {
      await AuthRepository().signInWithOtp(verificationId!, completeOtp);

      final userController = Get.find<UserController>();
      await userController.fetchUserProfile();
    } catch (e) {
      String error = AppHelper.getFirebaseErrorMessage(message: e.toString());
      AppUtils.showToast(
        label: error,
        vairant: ToastVariants.error,
      );
    } finally {
      otpLoading.value = false;
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
