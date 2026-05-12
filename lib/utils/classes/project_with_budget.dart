import 'package:buraq_enterprise_employee/models/allocated_amount_model.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';

class ProjectWithBudget {
  final ProjectModel project;
  final AllocatedAmountModel? allocatedAmount;

  const ProjectWithBudget({required this.project, this.allocatedAmount});

  double get allocated => allocatedAmount?.amount.toDouble() ?? 0.0;
  double get remaining => project.remainingBudget.toDouble();
}