import 'package:buraq_enterprise_employee/models/allocated_amount_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllocatedAmountRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'allocated_amounts';

  Future<void> allocateAmount({
    required String employeeId,
    required String projectId,
    required int amount,
    required String allocateBy,
    WriteBatch? batch,
  }) async {
    final batchToUse = batch ?? _firestore.batch();
    final docRef = _firestore.collection(collectionPath).doc();

    batchToUse.set(docRef, {
      'employeeId': employeeId,
      'projectId': projectId,
      'amount': amount,
      'allocateBy': allocateBy,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (batch == null) {
      await batchToUse.commit();
    }
  }

  Future<List<AllocatedAmountModel>> fetchAllocatedAmounts({
    required String projectId,
  }) async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .where('projectId', isEqualTo: projectId)
        .get();

    return snapshot.docs
        .map((doc) => AllocatedAmountModel.fromSnapshot(doc)) // ✅ fromSnapshot
        .toList();
  }

  Future<void> updateAllocatedAmount({
    required Map<String, int> allocationsToUpdate,
    required String projectId,
    required String updatedBy,
    required List<AllocatedAmountModel> allocatedAmounts,
  }) async {
    final batch = _firestore.batch();

    // ✅ Fetch fresh data
    final freshSnapshot = await _firestore
        .collection(collectionPath)
        .where('projectId', isEqualTo: projectId)
        .where('employeeId', whereIn: allocationsToUpdate.keys.toList())
        .get();

    // ✅ Build map: employeeId → {docId, oldAmount}
    final existingDocsMap = {
      for (final doc in freshSnapshot.docs)
        doc.data()['employeeId'] as String: {
          'docId': doc.id,
          'oldAmount': doc.data()['amount'] as int? ?? 0,
        },
    };

    int totalBudgetDifference = 0; // ✅ track net change only

    for (final entry in allocationsToUpdate.entries) {
      final employeeId = entry.key;
      final newAmount = entry.value;
      final existing = existingDocsMap[employeeId];

      if (existing == null) {
        // ✅ New allocation — full amount is deducted
        totalBudgetDifference += newAmount;

        final newDocRef = _firestore.collection(collectionPath).doc();
        batch.set(newDocRef, {
          'allocateBy': updatedBy,
          'amount': newAmount,
          'createdAt': FieldValue.serverTimestamp(),
          'employeeId': employeeId,
          'projectId': projectId,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': updatedBy,
        });
      } else {
        final oldAmount = existing['oldAmount'] as int;
        final difference =
            newAmount - oldAmount; // ✅ only the difference matters
        totalBudgetDifference += difference;

        final docRef = _firestore
            .collection(collectionPath)
            .doc(existing['docId'] as String);
        batch.update(docRef, {
          'amount': newAmount,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': updatedBy,
        });
      }
    }

    // ✅ Fetch project once outside the loop
    final projectSnapshot = await _firestore
        .collection('projects')
        .where('projectId', isEqualTo: projectId)
        .limit(1)
        .get();

    if (projectSnapshot.docs.isEmpty) return;

    final projectRef = projectSnapshot.docs.first.reference;
    batch.update(projectRef, {
      'remainingBudget': FieldValue.increment(-totalBudgetDifference),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });

    await batch.commit();
  }

Stream<List<AllocatedAmountModel>> fetchAllAllocatedAmountsStream() {
  return _firestore
      .collection(collectionPath)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AllocatedAmountModel.fromSnapshot(doc))
          .toList());
}
}
