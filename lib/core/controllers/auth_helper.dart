// core/utils/auth_helper.dart
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  static Future<T> call<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw Exception(
        AppHelper.getFirebaseErrorMessage(message: e.code),
      );
    } catch (e) {
      throw Exception(
        AppHelper.getFirebaseErrorMessage(message: e.toString()),
      );
    }
  }
}