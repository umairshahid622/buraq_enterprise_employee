import 'dart:io';

import 'package:buraq_enterprise_employee/utils/classes/app_verision_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppVersionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'versions';
  final String appName = 'employee';

  Future<VersionModel> getVersion() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final docId =
        'employeeApp_$platform';

    return _firestore
        .collection(collectionPath)
        .doc(docId)
        .get()
        .then((doc) => VersionModel.fromSnapshot(doc));
  }
}
