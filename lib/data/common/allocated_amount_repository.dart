import 'package:buraq_enterprise_employee/models/allocated_amount_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllocatedAmountRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'allocated_amounts';

  Future<double> getAllocatedAmount({required String employeeId}) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).where('employeeId', isEqualTo: employeeId).get().timeout(const Duration(seconds: 10));
      final List<AllocatedAmountModel> amounts = snapshot.docs.map((doc) => AllocatedAmountModel.fromSnapshot(doc)).toList();
      if (amounts.isEmpty) return 0;

      return amounts.fold<double>(0.0, (prev, next) => prev + next.amount);
    } catch (e) {
      rethrow;
    }
  } 

  
}
