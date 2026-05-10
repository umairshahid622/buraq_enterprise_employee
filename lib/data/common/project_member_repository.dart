import 'package:buraq_enterprise_employee/models/project_member_model.dart';
import 'package:buraq_enterprise_employee/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectMemberRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'project_members';

  Future<List<String>> getProjectIds( String empId) async {
    final snapshot = await FirestoreHelper.call(
      () => _firestore
          .collection(collectionPath)
          .where('employeeId', isEqualTo: empId)
          .get(),
    );

    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs
        .map((doc) => ProjectMember.fromSnapshot(doc).projectId)
        .where((id) => id.isNotEmpty)
        .toList();
  }
}
