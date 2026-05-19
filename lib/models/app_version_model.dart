import 'package:cloud_firestore/cloud_firestore.dart';

class VersionModel {
  final String currentVersion;
  final bool forceUpdate;
  final String updateMessage;
  final String downloadUrl;
  final DateTime? updatedAt;

  const VersionModel({
    required this.currentVersion,
    required this.forceUpdate,
    required this.updateMessage,
    required this.downloadUrl,
    this.updatedAt,
  });

  factory VersionModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VersionModel(
      currentVersion: data['currentVersion'] ?? '1.0.0',
      forceUpdate: data['forceUpdate'] ?? false,
      updateMessage: data['updateMessage'] ?? 'A new version is available. Please update to continue.',
      downloadUrl: data['downloadUrl'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}