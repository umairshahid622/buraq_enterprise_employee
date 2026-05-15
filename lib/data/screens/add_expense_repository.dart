import 'dart:io';

import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
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
    required String category,
    required String employeeId,
    required String projectId,
    required String projectName,
    required File receipt,
  }) async {
    final receiptUrl = await _uploadReceipt(receipt);
    final expenseDocRef = _firestore.collection(collectionPath).doc();
    await FirestoreHelper.call(
      () => expenseDocRef.set({
        'expenseId': expenseDocRef.id,
        'itemName': itemName,
        'itemQuantity': itemQuantity,
        'unitPrice': unitPrice,
        'additionalNotes': additionalNotes,
        'employeeId': employeeId,
        'projectId': projectId,
        'usedItems': 0,
        'returns': 0,
        'category':category,
        'projectName': projectName,
        'receiptUrl': receiptUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': _auth.currentUser!.uid,
        'updatedBy': _auth.currentUser!.uid,
      }),
    );
  }

  Future<(List<AddExpenseModel>,double)> fetchExpenses({
    required String employeeId,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> snapShot =
        await FirestoreHelper.call(
          () => _firestore
              .collection(collectionPath)
              .where('employeeId', isEqualTo: employeeId)
              .get(),
        );

    List<AddExpenseModel> expenses = snapShot.docs
        .map((doc) => AddExpenseModel.fromSnapshot(doc))
        .toList();
    
    final totalSpent = expenses.fold<double>(0.0, (prev, next) => prev + next.unitPrice * next.itemQuantity);

    return (expenses, totalSpent);
  }


  Future<void> updateUsedItems({required String expenseid, required int quantity}){
    
    return FirestoreHelper.call(
      () => _firestore.collection(collectionPath).doc(expenseid).update({
        'usedItems': FieldValue.increment(-quantity),
        'updatedAt': FieldValue.serverTimestamp(),
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
