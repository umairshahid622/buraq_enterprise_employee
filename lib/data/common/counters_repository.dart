import 'package:cloud_firestore/cloud_firestore.dart';

class CountersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'counters';

  Future<int> getNextCounterValue(String counterName) async {
    final counterRef = _firestore.collection(collectionPath).doc(counterName);

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      if (!snapshot.exists) {
        transaction.set(counterRef, {'value': 1});
        return 1;
      }

      final currentValue = snapshot.data()!['value'] as int;
      final nextValue = currentValue + 1;

      transaction.update(counterRef, {'value': nextValue});
      return nextValue;
    });
  }
}