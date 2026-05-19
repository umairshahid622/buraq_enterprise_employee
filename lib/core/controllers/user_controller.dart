import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_employee/data/auth/employee_repository.dart';
import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends BaseController {
  final AuthRepository _authRepo = AuthRepository();

  final EmployeeRepository _employeeRepository = EmployeeRepository();

  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  /// Public getter for reactive user
  Rx<UserModel?> get userRx => _user;

  /// Public getter
  UserModel? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  // -------------------------------
  // Load user on app start
  // -------------------------------
  Future<void> initializeApp() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await fetchUserProfile();
    }
  }

  // -------------------------------
  // Fetch profile
  // -------------------------------
  Future<void> fetchUserProfile() async {
    final (data, success) = await safeCall(
      () => _employeeRepository.getEmployeeData(),
    );

    if (success && data != null) {
      _user.value = data;
    } else {
      _user.value = null;
    }
  }

  Future<void> signOut() async {
    final (data, success) = await safeCall(() => _authRepo.signOut());
    if (success) {
      Get.deleteAll();
      _user.value = null;
    }
  }
}
