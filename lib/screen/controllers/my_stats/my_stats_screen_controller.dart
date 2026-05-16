import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/common/main_layout_controller.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:get/get.dart';

class CategorySpend {
  final String category;
  final double amount;

  const CategorySpend({required this.category, required this.amount});
}

class MyStatsScreenController extends BaseController {
  late final MainLayoutDataController _mainLayoutController;

  @override
  void onInit() {
    super.onInit();
    _mainLayoutController = Get.find<MainLayoutDataController>();
    if (!_mainLayoutController.hasLoadedData) {
      refreshStats();
    }
  }

  Future<void> refreshStats() async {
    await _mainLayoutController.fetchData();
    update();
  }

  bool get isStatsLoading =>
      _mainLayoutController.isLoading.value ||
      !_mainLayoutController.hasLoadedData;

  bool get hasData =>
      _mainLayoutController.projectsWithBudget.isNotEmpty ||
      _mainLayoutController.expenses.isNotEmpty ||
      _mainLayoutController.allocatedAmount > 0;

  double get allocatedAmount => _mainLayoutController.allocatedAmount;
  double get spentAmount => _mainLayoutController.spentAmount;
  double get availableAmount => allocatedAmount - spentAmount;
  int get projectCount => _mainLayoutController.projectsWithBudget.length;
  int get expenseCount => _mainLayoutController.expenses.length;

  double get budgetUsedPercentage {
    if (allocatedAmount <= 0) return 0;
    return ((spentAmount / allocatedAmount) * 100).clamp(0, 100).toDouble();
  }

  double get averageExpenseAmount {
    if (expenseCount == 0) return 0;
    return spentAmount / expenseCount;
  }

  List<ProjectWithBudget> get projectsBySpend {
    final projects = [..._mainLayoutController.projectsWithBudget];
    projects.sort((a, b) => b.spent.compareTo(a.spent));
    return projects;
  }

  List<CategorySpend> get categorySpends {
    final totals = <String, double>{};

    for (final expense in _mainLayoutController.expenses) {
      final category = expense.category.trim().isEmpty
          ? 'Uncategorized'
          : expense.category.trim();
      totals.update(
        category,
        (value) => value + _expenseAmount(expense),
        ifAbsent: () => _expenseAmount(expense),
      );
    }

    final categories = totals.entries
        .map((entry) => CategorySpend(category: entry.key, amount: entry.value))
        .toList();
    categories.sort((a, b) => b.amount.compareTo(a.amount));
    return categories;
  }

  CategorySpend? get topCategory =>
      categorySpends.isEmpty ? null : categorySpends.first;

  List<AddExpenseModel> get recentExpenses {
    final expenses = [..._mainLayoutController.expenses];
    expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return expenses.take(5).toList();
  }

  double _expenseAmount(AddExpenseModel expense) {
    final quantityAfterReturns = expense.itemQuantity - expense.returns;
    return expense.unitPrice.toDouble() *
        quantityAfterReturns.clamp(0, 1 << 31).toDouble();
  }
}
