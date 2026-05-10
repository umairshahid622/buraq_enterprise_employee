import 'package:buraq_enterprise_employee/models/allocated_amount_model.dart';
import 'package:buraq_enterprise_employee/utils/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllocatedAmountRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'allocated_amounts';

  Future<(List<AllocatedAmountModel>, double)> getAllocatedAmount({required String employeeId}) async {    
      final snapshot = await FirestoreHelper.call(
        () => _firestore.collection(collectionPath).where('employeeId', isEqualTo: employeeId).get(),        
      );
      final List<AllocatedAmountModel> allocatedAmounts = snapshot.docs.map((doc) => AllocatedAmountModel.fromSnapshot(doc)).toList();
      if (allocatedAmounts.isEmpty) return (<AllocatedAmountModel>[], 0.0);
      final totalAmount = allocatedAmounts.fold<double>(0.0, (prev, next) => prev + next.amount);
      return (allocatedAmounts, totalAmount);    
  }   
}
