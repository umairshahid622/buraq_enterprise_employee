import 'dart:io';

import 'package:buraq_enterprise_employee/utils/classes/app_verision_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppVersionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'versions';
  final String appName = 'employee';

  Stream<VersionModel> versionStream() {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final docId =
        'employeeApp_$platform'; // → "employeeApp_android" or "employeeApp_ios"

    return _firestore
        .collection('versions')
        .doc(docId)
        .snapshots()
        .map((doc) => VersionModel.fromSnapshot(doc));
  }
}
