import 'package:buraq_enterprise_employee/utils/auth_helper.dart';
import 'package:buraq_enterprise_employee/data/auth/employee_repository.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmployeeRepository _employeeRepository = EmployeeRepository();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verId) onCodeSent,
  }) async {
    final completer = Completer<void>();

    // ✅ format and validate first
    final formattedPhone = AppHelper.getFormattedPhoneNumber(
      phoneNumber: phoneNumber,
    );

    // ✅ FirestoreHelper is inside EmployeeRepository already
    final adminExist = await _employeeRepository.checkAdminExist(
      phoneNumber: formattedPhone,
    );

    if (adminExist) {
      throw Exception('This number is registered as an admin account.');
    }
    
    final employeeExist = await _employeeRepository.checkEmployeeExist(
      phoneNumber: formattedPhone,
    );
    
    if (!employeeExist) {
      throw Exception('This number is not registered as an employee account.');
    }

    // ✅ wrap Auth call in AuthHelper
    await AuthHelper.call(() async {
      _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if (!completer.isCompleted) completer.complete();
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("verificationFailed error: $e");
          if (!completer.isCompleted) {
            completer.completeError(
              Exception(AppHelper.getFirebaseErrorMessage(message: e.code)),
            );
          }
        },
        codeSent: (String verId, int? resendToken) {
          onCodeSent(verId);
          if (!completer.isCompleted) completer.complete();
        },
        codeAutoRetrievalTimeout: (String verId) {
          if (!completer.isCompleted) completer.complete();
        },
      );

      await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
            'Phone verification timed out. Please try again.',
          );
        },
      );
    });
  }

  Future<UserCredential> signInWithOtp(String verId, String smsCode) async {
    // ✅ wrap in AuthHelper — no manual try/catch
    return await AuthHelper.call(() async {
      final credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // ✅ FirestoreHelper is inside initializeRecord already
      await _employeeRepository.initializeRecord(userCredential.user);

      return userCredential;
    });
  }

  Future<void> signOut() async {
    // ✅ wrap in AuthHelper
    await AuthHelper.call(() => _auth.signOut());
  }
}
