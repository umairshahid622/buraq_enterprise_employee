import 'package:cloud_firestore/cloud_firestore.dart';

class AppVersionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'versions';

  

}