import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpenseModel {
  String itemName;
  int itemQuantity;
  int unitPrice;
  String additionalNotes;
  String employeeId;
  String projectId;
  String projectName;
  String receiptUrl;
  String createdBy;
  String updatedBy;

  Timestamp createdAt;
  Timestamp updatedAt;

  AddExpenseModel({
    required this.itemName,
    required this.itemQuantity,
    required this.unitPrice,
    required this.additionalNotes,
    required this.employeeId,
    required this.projectId,
    required this.projectName,
    required this.receiptUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory AddExpenseModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return AddExpenseModel(
      itemName: data['itemName'] ?? '',
      itemQuantity: data['itemQuantity'] ?? '',
      unitPrice: data['unitPrice'] ?? '',
      additionalNotes: data['additionalNotes'] ?? '',
      employeeId: data['employeeId'] ?? '',
      projectId: data['projectId'] ?? '',
      projectName: data['projectName'] ?? '',
      receiptUrl: data['receiptUrl'] ?? '',
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
    );
  }
}
