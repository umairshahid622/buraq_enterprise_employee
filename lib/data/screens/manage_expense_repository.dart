import 'package:buraq_enterprise_employee/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String returnItemsCollectionPath = 'return_items';
  final String useItemsCollectionPath = 'use_items';


  Future<void> manageItemsLog({
    required bool returnItem,
    required String expenseId,
    required String employeeId,
    required String projectId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    required String additionalNotes,    
  }){
    
    return FirestoreHelper.call(
      () => _firestore.collection(returnItem ? returnItemsCollectionPath : useItemsCollectionPath).doc().set({
        'expenseId': expenseId,
        'employeeId': employeeId,
        'projectId': projectId,
        'itemName': itemName,
        'itemCategory': itemCategory,
        'quantity': quantity,
        'additionalNotes': additionalNotes,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': _auth.currentUser!.uid,
        'updatedBy': _auth.currentUser!.uid,
      }),
    );
  }
    
}