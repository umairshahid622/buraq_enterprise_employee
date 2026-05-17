import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:buraq_enterprise_employee/data/common/app_versions_repository.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/config/app_session.dart';

class SplashController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final AppVersionsRepository _versionRepo = AppVersionsRepository();
  late final UserController _userController;

  @override
  void onInit() {
    super.onInit();

    _userController = Get.find<UserController>();
    checkVersion();
  }

  Future<void> checkVersion() async {
    _versionRepo.versionStream().listen((version) async {
      final packageInfo = await PackageInfo.fromPlatform();
      final installedVersion = packageInfo.version; // e.g. "1.0.3"

      final isOutdated = _isOutdated(
        installed: installedVersion,
        required: version.currentVersion,
      );

      if (true) {
        await Future.delayed(const Duration(milliseconds: 500));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppUtils.appDialog(
            context: Get.context!,
            onSubmitCallBack: () {},
            isLoading: () => false,
            icon: Icons.logout,
            title: "Log Out?",
            message:
                "Are you sure you want to logout? Any unsaved data will be lost.",
            subMessage: "",
            submitButtonText: "Logout",
          );
        });

        return;
      }
      await _bootstrap();
    });
  }

  bool _isOutdated({required String installed, required String required}) {
    final i = installed.split('.').map(int.parse).toList();
    final r = required.split('.').map(int.parse).toList();

    for (int idx = 0; idx < r.length; idx++) {
      if (i[idx] < r[idx]) return true;
      if (i[idx] > r[idx]) return false;
    }
    return false;
  }

  Future<void> _bootstrap() async {
    final bootStart = DateTime.now();
    final user = _auth.currentUser;

    if (user != null) {
      await _userController.fetchUserProfile();
    } else {
      _userController.signOut();
    }

    final minSplashDuration = const Duration(milliseconds: 1500);
    final elapsed = DateTime.now().difference(bootStart);
    if (elapsed < minSplashDuration) {
      await Future.delayed(minSplashDuration - elapsed);
    }

    appSession.setReady();
  }
}
