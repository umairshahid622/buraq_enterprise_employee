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

  final RxBool isLoading = false.obs;

  /// Public getter
  UserModel? get user => _user.value;

  bool get isLoggedIn => user != null;

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
    } else {
      await signOut();
    }
  }

  // -------------------------------
  // Fetch profile
  // -------------------------------
  Future<void> fetchUserProfile() async {
    final data = await safeCall(
      () => _employeeRepository.getEmployeeData(),
      onStart: () => isLoading.value = true,
      onComplete: () => isLoading.value = false,
    );

    if (data != null) {
      _user.value = data;
    } else {
      _user.value = null;
      await signOut();
    }
  }

  Future<void> signOut() async {
    await safeCall(() => _authRepo.signOut());
    _user.value = null;
  }
}
