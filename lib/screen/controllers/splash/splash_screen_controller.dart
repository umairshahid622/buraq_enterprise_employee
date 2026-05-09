import 'package:buraq_enterprise_employee/screen/controllers/common/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/config/app_session.dart';

class SplashController extends GetxController {
  final _auth = FirebaseAuth.instance;

  // repository
  // final EmployeeRepository employeeRepository = EmployeeRepository();
  // final ProjectRepository projectRepository = ProjectRepository();
  // final ProjectMemberRepository _projectMemberRepository = ProjectMemberRepository();

  //Lists
  

  //controllers
  late final UserController _userController;

  @override
  void onInit() {
    super.onInit();

    _userController = Get.find<UserController>();

    _bootstrap();
  }  

  Future<void> _bootstrap() async {
    final bootStart = DateTime.now();
    final user = _auth.currentUser;

    if (user != null) {
      await _userController.fetchUserProfile();      

      

      await Future.wait([
        
      ]);
    } else {
      
    }

    final minSplashDuration = const Duration(milliseconds: 1500);
    final elapsed = DateTime.now().difference(bootStart);
    if (elapsed < minSplashDuration) {
      await Future.delayed(minSplashDuration - elapsed);
    }

    appSession.setReady();
  }
}
