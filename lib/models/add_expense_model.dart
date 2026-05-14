import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpenseModel {
  String expenseId;
  String itemName;
  int itemQuantity;
  int usedItems;
  int unitPrice;
  String additionalNotes;
  String employeeId;
  int returns;
  String projectId;
  String category;
  String projectName;
  String receiptUrl;
  String createdBy;
  String updatedBy;

  DateTime createdAt; // ✅ DateTime not Timestamp
  DateTime updatedAt; // ✅ DateTime not Timestamp

  AddExpenseModel({
    required this.expenseId,
    required this.itemName,
    required this.itemQuantity,
    required this.usedItems,
    required this.unitPrice,
    required this.additionalNotes,
    required this.employeeId,
    required this.returns,
    required this.projectId,
    required this.category,
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
      expenseId: data['expenseId'] ?? '',
      itemName: data['itemName'] ?? '',
      itemQuantity: data['itemQuantity'] ?? 0,
      usedItems: data['usedItems'] ?? 0,
      unitPrice: data['unitPrice'] ?? 0,
      additionalNotes: data['additionalNotes'] ?? '',
      employeeId: data['employeeId'] ?? '',
      returns: data['returns'] ?? 0,
      projectId: data['projectId'] ?? '',
      category: data['category'] ?? '',
      projectName: data['projectName'] ?? '',
      receiptUrl: data['receiptUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(), // ✅ Timestamp → DateTime
      updatedAt: (data['updatedAt'] as Timestamp).toDate(), // ✅ Timestamp → DateTime
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
    );
  }

  @override
  String toString() {
    return 'AddExpenseModel(projectId: $projectId, unitPrice: $unitPrice, itemQuantity: $itemQuantity)';
  }
}