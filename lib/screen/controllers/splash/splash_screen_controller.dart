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
  final RxBool _isUpdateActionLoading = false.obs;
  bool _hasStartedVersionCheck = false;

  @override
  void onInit() {
    super.onInit();
    _userController = Get.find<UserController>();
  }

  Future<void> seedVersionData() async {
    try {
    _versionRepo.seedVersionData();
      
    } catch (e) {
      debugPrint("SEEDING ERROR $e");
    }
  }

  Future<void> checkVersion(BuildContext context) async {
    if (_hasStartedVersionCheck) return;
    _hasStartedVersionCheck = true;

    final version = await _versionRepo.getVersion();
    final packageInfo = await PackageInfo.fromPlatform();
    final installedVersion = packageInfo.version;

    debugPrint("installedVersion: $installedVersion");
    debugPrint("currentVersion: ${version.currentVersion}");

    final isOutdated = _isOutdated(
      installed: installedVersion,
      required: version.currentVersion,
    );

    debugPrint("isOutdated: $isOutdated");

    if (isOutdated) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!context.mounted) return;

      await AppUtils.appDialog(
        context: context,
        onSubmitCallBack: () {},
        isLoading: () => _isUpdateActionLoading.value,
        icon: Icons.system_update_alt_rounded,
        title: version.forceUpdate ? "Update Required" : "Update Available",
        message: version.forceUpdate
            ? "A critical update is required to continue using the app."
            : "A new version is available. We recommend updating.",
        subMessage: "Version : ${version.currentVersion} is available.",
        submitButtonText: "Update Now",
        barrierDismissible: false,
        cancelButtonText: "Later",
        onCancelCallBack: version.forceUpdate
            ? null
            : () {
                Navigator.of(context, rootNavigator: true).pop();
                _bootstrap();
              },
      );

      return;
    }

    if (!isOutdated) await _bootstrap();
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
