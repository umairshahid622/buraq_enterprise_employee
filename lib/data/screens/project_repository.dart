import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:buraq_enterprise_employee/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final String collectionPath = 'projects';

  Future<List<ProjectModel>> getProjectsByIds({
    required List<String> projectIds,
  }) async {
    if (projectIds.isEmpty) return [];

    // ✅ chunk into groups of 10 — whereIn limit
    final chunks = <List<String>>[];
    for (int i = 0; i < projectIds.length; i += 10) {
      chunks.add(
        projectIds.sublist(
          i,
          (i + 10) > projectIds.length ? projectIds.length : i + 10,
        ),
      );
    }

    // ✅ fetch all chunks in parallel
    final results = await Future.wait(
      chunks.map((chunk) => _fetchByChunk(chunk)),
    );

    return results.expand((list) => list).toList();
  }

  Future<List<ProjectModel>> _fetchByChunk(List<String> ids) async {
    final snapshot = await FirestoreHelper.call(
      () => _firestore
          .collection(collectionPath)
          .where('projectId', whereIn: ids)
          .get(),
    );

    return snapshot.docs.map((doc) => ProjectModel.fromSnapshot(doc)).toList();
  }
}
