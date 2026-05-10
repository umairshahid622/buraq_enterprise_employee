import 'dart:async';

import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static const _timeout = Duration(seconds: 10);

  static Future<T> call<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(_timeout);
    } on FirebaseException catch (e) {
      throw Exception(
        AppHelper.getFirebaseErrorMessage(message: e.code),
      );
    } on TimeoutException {
      throw Exception('Request timed out. Please check your connection.');
    } catch (e) {
      throw Exception(
        AppHelper.getFirebaseErrorMessage(message: e.toString()),
      );
    }
  }
}