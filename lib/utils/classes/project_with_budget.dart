import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/models/allocated_amount_model.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';

class ProjectWithBudget {
  final ProjectModel project;
  final AllocatedAmountModel? allocatedAmount;
  final List<AddExpenseModel> expenses;

  const ProjectWithBudget({
    required this.project,
    this.allocatedAmount,
    this.expenses = const [],
  });

  double get allocated => allocatedAmount?.amount.toDouble() ?? 0.0;
  double get remaining => project.remainingBudget.toDouble();
  double get spent => expenses.fold(
    0.0,
    (sum, e) => sum + (e.unitPrice.toDouble() * (e.itemQuantity.toDouble() - e.returns.toDouble())),
  );

  @override
  String toString() {
    return '''
ProjectWithBudget(
  project: $project,
  allocatedAmount: $allocatedAmount,
  expenses: $expenses,
  allocated: $allocated,
  remaining: $remaining,
  spent: $spent,
)''';
  }
}
