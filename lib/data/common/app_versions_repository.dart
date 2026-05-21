import 'dart:io';

import 'package:buraq_enterprise_employee/models/app_version_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppVersionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'versions';
  final String appName = 'employee';

  Future<void> seedVersionData() async {
    final batch = _firestore.batch();

    final versions = {
      'employeeApp_android': {
        'currentVersion': '1.0.0',
        'forceUpdate': false,
        'updateMessage':
            'A new version is available. Please update to continue.',
        'downloadUrl': '',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      'employeeApp_ios': {
        'currentVersion': '1.0.0',
        'forceUpdate': false,
        'updateMessage':
            'A new version is available. Please update to continue.',
        'downloadUrl': '',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      'adminApp_android': {
        'currentVersion': '1.0.0',
        'forceUpdate': false,
        'updateMessage':
            'A new version is available. Please update to continue.',
        'downloadUrl': '',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      'adminApp_ios': {
        'currentVersion': '1.0.0',
        'forceUpdate': false,
        'updateMessage':
            'A new version is available. Please update to continue.',
        'downloadUrl': '',
        'updatedAt': FieldValue.serverTimestamp(),
      },
    };

    // ✅ batch write — all 4 docs in one request
    versions.forEach((docId, data) {
      final ref = _firestore.collection('versions').doc(docId);
      batch.set(ref, data);
    });

    await batch.commit();
    debugPrint('✅ Version data seeded successfully');
  }

  Future<VersionModel> getVersion() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final docId = 'employeeApp_$platform';

    return _firestore
        .collection(collectionPath)
        .doc(docId)
        .get()
        .then((doc) => VersionModel.fromSnapshot(doc));
  }
}
