
import 'package:buraq_enterprise_employee/data/common/counters_repository.dart';
import 'package:buraq_enterprise_employee/data/common/project_member_repository.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CountersRepository _countersRepository = CountersRepository();
  final ProjectMemberRepository _projectMemberRepository =
      ProjectMemberRepository();
  final String collectionPath = 'projects';

  Stream<List<ProjectModel>> fetchProjects() {
    return _db.collection(collectionPath).snapshots().map((snapShot) {      
      return snapShot.docs.map((doc) {
        return ProjectModel.fromSnapshot(doc);
      }).toList();
    });
  }

  Future<void> addProject({
    required String projectName,
    required String projectDiscription,
    required DateTime startDate,
    required DateTime endDate,
    required int totalBudgetAllocated,
    required List<String> employeeIds,
  }) async {
    final projectId = await _generateProjectId();
    final DocumentReference projectRef = _db
        .collection(collectionPath)
        .doc(projectId);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot projectSnap = await transaction.get(projectRef);

      if (projectSnap.exists) {
        throw Exception("Project '$projectName' already exists!");
      }
      

      transaction.set(projectRef, {
        'projectId': projectId,
        'projectName': projectName,
        'projectDiscription': projectDiscription,
        'startDate': startDate,
        'endDate': endDate,
        'totalBudgetAllocated': totalBudgetAllocated,
        'remainingBudget': totalBudgetAllocated,
        'status': 'active',
        'createdBy': _auth.currentUser!.uid,
        'updatedBy': _auth.currentUser!.uid,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (employeeIds.isEmpty) return;
      _projectMemberRepository.addProjectMember(
        projectId: projectId,
        employeeIds: employeeIds,
        assignedBy: _auth.currentUser!.uid,
      );
    });
  }

  Future<String> _generateProjectId() async {
    // Use CountersRepository to reserve a sequential project counter
    // and format it as PRJ###. Retry a few times in case of collision.
    for (int attempt = 0; attempt < 5; attempt++) {
      final next = await _countersRepository.getNextCounterValue('projects');
      final projectId = 'PRJ${next.toString().padLeft(3, '0')}';
      final doc = await _db.collection(collectionPath).doc(projectId).get();
      if (!doc.exists) {
        return projectId;
      }
      // If doc exists, loop and try again (counter value was consumed).
    }

    throw Exception(
      'Failed to generate unique project ID after multiple attempts.',
    );
  }
  

  Future<void> updateProjectBudget({
    required String projectId,
    required int newTotalBudget,
  }) async {
    if (newTotalBudget < 0) {
      throw Exception("Amount cannot be negative.");
    }

    final projectRef = _db.collection(collectionPath).doc(projectId);

    await _db.runTransaction((transaction) async {
      final projectSnap = await transaction.get(projectRef);
      if (!projectSnap.exists) {
        throw Exception("Project not found.");
      }

      final projectData = projectSnap.data() as Map<String, dynamic>;
      final int currentTotal =
          (projectData['totalBudgetAllocated'] ?? 0) as int;
      final int currentRemaining = (projectData['remainingBudget'] ?? 0) as int;

      final int delta = newTotalBudget - currentTotal;
      final int newRemaining = currentRemaining + delta;

      if (newRemaining < 0) {
        throw Exception("New budget is less than already allocated amount.");
      }

      transaction.update(projectRef, {
        'totalBudgetAllocated': newTotalBudget,
        'remainingBudget': newRemaining,
        'updatedBy': _auth.currentUser!.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

}
