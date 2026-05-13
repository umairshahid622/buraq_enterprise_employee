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
      itemQuantity: data['itemQuantity'] ?? 0,
      unitPrice: data['unitPrice'] ?? 0,
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

    @override
  String toString() {
    return 'AddExpenseModel(projectId: $projectId, unitPrice: $unitPrice, itemQuantity: $itemQuantity)';
  }
}
