import 'package:buraq_enterprise_employee/data/auth/employee_repository.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmployeeRepository _employeeRepository = EmployeeRepository();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verId) onCodeSent,
  }) async {
    try {
      // Standardize the Pakistani number format
      String formattedPhone = AppUtils.getFormattedPhoneNumber(
        phoneNumber: phoneNumber,
      );
      bool adminExist = await _employeeRepository.checkAdminExist(
        phoneNumber: formattedPhone,
      );

      if (adminExist) {
        String error = AppUtils.getFirebaseErrorMessage(
          message: "Your account is not active. Please contact admin.",
        );
        throw Exception(error);
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(
            AppUtils.getFirebaseErrorMessage(message: e.toString()),
          );
        },
        codeSent: (String verId, int? resendToken) {
          onCodeSent(verId);
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
    } catch (e) {
      throw Exception(AppUtils.getFirebaseErrorMessage(message: e.toString()));
    }
  }

  // Final Sign In
  Future<UserCredential> signInWithOtp(String verId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      await _employeeRepository.initializeRecord(userCredential.user);

      return userCredential;
    } on FirebaseAuthException {
      // Re-throw Firebase Auth exceptions so they can be handled upstream
      rethrow;
    } catch (e) {
      // Wrap other exceptions
      throw Exception("Sign in failed: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout Failed: $e");
    }
  }
}
