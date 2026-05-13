import 'dart:io';

import 'package:buraq_enterprise_employee/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String collectionPath = 'add_expenses';

  Future<void> addExpense({
    required String itemName,
    required int itemQuantity,
    required int unitPrice,
    required String additionalNotes,
    required String employeeId,
    required String projectId,
    required String projectName,
    required File receipt,
  }) async {
    final receiptUrl = await _uploadReceipt(receipt);

    await FirestoreHelper.call(
      () => _firestore.collection(collectionPath).doc().set({
        'itemName': itemName,
        'itemQuantity': itemQuantity,
        'unitPrice': unitPrice,
        'additionalNotes': additionalNotes,
        'employeeId': employeeId,
        'projectId': projectId,
        'projectName': projectName,
        'receiptUrl': receiptUrl, 
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': _auth.currentUser!.uid,
        'updatedBy': _auth.currentUser!.uid,
      }),
    );
  }

  Future<String> _uploadReceipt(File file) async {
    final uid = _auth.currentUser!.uid;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = 'receipts/$uid/$timestamp.jpg';
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await uploadTask.ref.getDownloadURL();
  }
}
