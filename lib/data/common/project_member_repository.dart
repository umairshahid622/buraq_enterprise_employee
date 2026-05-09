import 'package:buraq_enterprise_employee/models/project_member_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectMemberRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'project_members';

  Future<void> addProjectMember({
    required String projectId,
    required String assignedBy,
    required List<String> employeeIds,
  }) async {
    final batch = _firestore.batch();

    for (final employeeId in employeeIds) {
      final docRef = _firestore.collection(collectionPath).doc();
      batch.set(docRef, {
        'projectId': projectId,
        'employeeId': employeeId,
        'assignedBy': assignedBy,
        'updatedBy': assignedBy,
        'updatedAt': FieldValue.serverTimestamp(),
        'assignedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> removeProjectMember({
    required String projectId,
    required String employeeId,
  }) async {
    final querySnapshot = await _firestore
        .collection(collectionPath)
        .where('projectId', isEqualTo: projectId)
        .where('employeeId', isEqualTo: employeeId)
        .get();

    if (querySnapshot.docs.isEmpty) return;

    // Fetch allocated amount docs to delete
    final allocatedAmountSnapshot = await _firestore
        .collection('allocated_amounts')
        .where('projectId', isEqualTo: projectId)
        .where('employeeId', isEqualTo: employeeId)
        .get();

    final batch = _firestore.batch();

    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete allocated amount docs in the same batch
    for (final doc in allocatedAmountSnapshot.docs) {
      batch.delete(doc.reference);
    }

    final projectRef = _firestore.collection('projects').doc(projectId);
    final int freedAmount = allocatedAmountSnapshot.docs.fold(
      0,
      (numb, doc) => numb + (doc.data()['amount'] as int? ?? 0),
    );

    batch.update(projectRef, {
      'remainingBudget': FieldValue.increment(freedAmount),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Stream<List<ProjectMember>> fetchProjectMembers(String projectId) {
    return _firestore
        .collection(collectionPath)
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map(
          (snapShot) => snapShot.docs.map(ProjectMember.fromSnapshot).toList(),
        );
  }

  Stream<List<ProjectMember>> fetchAllProjectMembers() {
    return _firestore
        .collection(collectionPath)
        .snapshots()
        .map(
          (snapShot) => snapShot.docs.map(ProjectMember.fromSnapshot).toList(),
        );
  }
}
