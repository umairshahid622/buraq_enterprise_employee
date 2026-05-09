import 'package:buraq_enterprise_employee/data/auth/auth_repository.dart';
import 'package:buraq_enterprise_employee/data/auth/employee_repository.dart';
import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
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
    try {
      isLoading.value = true;

      final UserModel? data = await _employeeRepository.getEmployeeData();

      if (data != null) {
        _user.value = data;
      } else {
        _user.value = null;
        await signOut();
        
      }
    } catch (e) {
      _user.value = null;

      Get.log('Fetch User Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // -------------------------------
  // Clear user (Logout)
  // -------------------------------
  Future<void> signOut() async {
    await _authRepo.signOut().then( (_) {
      _user.value = null;
    }).catchError((e) {
      Get.log('Sign Out Error: $e');
    });
  }
}
