import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'employees';

  Future<void> initializeRecord(User? user) async {
    if (user == null || user.phoneNumber == null) return;

    try {
      final query = await _firestore
          .collection(collectionPath)
          .where('phone', isEqualTo: user.phoneNumber)
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));

      if (query.docs.isEmpty) {
        throw Exception('No employee record found for this phone number');
      }

      final employeeDoc = query.docs.first;      
      if (employeeDoc.data()['uid'] == null) {
        await employeeDoc.reference.update({
          'uid': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') rethrow;
      rethrow;
    }
  }

  Future<UserModel?> getEmployeeData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final query = await _firestore
          .collection(collectionPath)
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));

      if (query.docs.isEmpty) return null;

      return UserModel.fromMap(query.docs.first.data());
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') rethrow;
      return null;
    }
  }

  Future<bool> checkAdminExist({required String phoneNumber}) async {
    final QuerySnapshot snapShot = await _firestore
        .collection('admins')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    return snapShot.docs.isNotEmpty;
  }
}
