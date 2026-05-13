import 'package:cloud_firestore/cloud_firestore.dart';

class AllocatedAmountModel {
  String docId; 
  String allocatedBy;
  int amount;
  DateTime createdAt;
  String employeeId;
  String projectId;
  DateTime updatedAt;

  AllocatedAmountModel({
    required this.docId,
    required this.allocatedBy,
    required this.amount,
    required this.createdAt,
    required this.employeeId,
    required this.projectId,
    required this.updatedAt,
  });

  factory AllocatedAmountModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return AllocatedAmountModel(
      docId: doc.id,
      allocatedBy: data['allocateBy'] ?? '',
      amount: data['amount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      employeeId: data['employeeId'] ?? '',
      projectId: data['projectId'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'allocateBy': allocatedBy,
      'amount': amount,
      'createdAt': createdAt,
      'employeeId': employeeId,
      'projectId': projectId,
      'updatedAt': updatedAt,
    };
  }
}