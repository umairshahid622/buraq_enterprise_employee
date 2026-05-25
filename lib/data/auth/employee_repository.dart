import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:buraq_enterprise_employee/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'employees';

  Future<void> initializeRecord(User? user) async {
    if (user == null || user.email == null) return;
    final query = await FirestoreHelper.call(
      () => _firestore
          .collection(collectionPath)
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get(),
    );

    if (query.docs.isEmpty) throw Exception('No employee record found for this phone number');
    final employeeDoc = query.docs.first;
    if (employeeDoc.data()['uid'] == null) {
      final firstName = user.displayName?.split(' ')[0];
      final lastName = user.displayName?.split(' ')[1];

      await employeeDoc.reference.update({
        'uid': user.uid,
        'first_name': firstName,
        'last_name': lastName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<UserModel?> getEmployeeData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    debugPrint("User IDDD::: ${user.uid}");

    final query = await FirestoreHelper.call(
      () => _firestore.collection(collectionPath).doc(user.uid).get(),
    );

    if (!query.exists || query.data() == null) return null;

    return UserModel.fromMap(query.data()!);
  }

  Future<bool> checkAdminExist({required String email}) async {
    final QuerySnapshot snapShot = await FirestoreHelper.call(
      () => _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get(),
    );
    return snapShot.docs.isNotEmpty;
  }

  Future<bool> checkEmployeeExist({required String email}) async {
    final QuerySnapshot snapShot = await FirestoreHelper.call(
      () => _firestore
          .collection(collectionPath)
          .where('email', isEqualTo: email)
          .limit(1)
          .get(),
    );
    return snapShot.docs.isNotEmpty;
  }
}
