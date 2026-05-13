import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:buraq_enterprise_employee/data/common/allocated_amount_repository.dart';
import 'package:buraq_enterprise_employee/data/common/project_member_repository.dart';
import 'package:buraq_enterprise_employee/data/screens/add_expense_repository.dart';
import 'package:buraq_enterprise_employee/data/screens/project_repository.dart';
import 'package:buraq_enterprise_employee/models/add_expense_model.dart';
import 'package:buraq_enterprise_employee/models/allocated_amount_model.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:buraq_enterprise_employee/models/user_model.dart';
import 'package:buraq_enterprise_employee/utils/classes/project_with_budget.dart';
import 'package:get/get.dart';

class MainLayoutDataController extends BaseController {
  //repositories
  final AllocatedAmountRepository _allocatedAmountRepository =
      AllocatedAmountRepository();
  final ProjectMemberRepository _projectMemberRepository =
      ProjectMemberRepository();
  final ProjectRepository _projectRepo = ProjectRepository();
  final AddExpenseRepository _addExpenseRepository = AddExpenseRepository();
  //controllers
  late final UserController _userController;

  //variables
  double _totalAllocatedAmount = 0.0;
  double _spentAmount = 0.0;

  //Lists
  List<ProjectModel> _projects = [];
  List<AllocatedAmountModel> _allocatedAmounts = [];
  List<ProjectWithBudget> _projectsWithBudget = [];
  List<AddExpenseModel> _expenses = [];

  @override
  void onInit() {
    super.onInit();
    _userController = Get.find<UserController>();

    if (_userController.user?.empId.isNotEmpty == true) {
      fetchData();
      return;
    }

    isLoading.value = true;
    update();

    ever<UserModel?>(_userController.userRx, (UserModel? user) {
      if (user != null && user.empId.isNotEmpty) {
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    final empId = _userController.userRx.value?.empId;
    if (empId == null || empId.isEmpty) return;

    final results = await safeCall(
      () => Future.wait([
        _allocatedAmountRepository.getAllocatedAmount(employeeId: empId),
        _addExpenseRepository.fetchExpenses(employeeId: empId),
        _fetchProjects(empId),
      ]),
    );

    if (results != null) {
      final (list, total) = results[0] as (List<AllocatedAmountModel>, double);
      _allocatedAmounts = list;
      _totalAllocatedAmount = total;

      final (expenseList, totalExpense) = results[1] as (List<AddExpenseModel>, double);
      _expenses = expenseList;
      _spentAmount = totalExpense;

      _projects = results[2] as List<ProjectModel>;
      _projectsWithBudget = _joinProjectsWithBudget();
      update();
    }
  }

  Future<List<ProjectModel>> _fetchProjects(String empId) async {
    final projectIds = await _projectMemberRepository.getProjectIds(empId);
    if (projectIds.isEmpty) return [];
    return _projectRepo.getProjectsByIds(projectIds: projectIds);
  }

  List<ProjectWithBudget> _joinProjectsWithBudget() {
    final budgetMap = {for (final a in _allocatedAmounts) a.projectId: a};

    // ✅ Group all expenses by projectId
    final expensesMap = <String, List<AddExpenseModel>>{};
    for (final e in _expenses) {
      expensesMap.putIfAbsent(e.projectId, () => []).add(e);
    }
    print("Join Called");

    return _projects.map((project) {
      return ProjectWithBudget(
        project: project,
        allocatedAmount: budgetMap[project.projectId],
        expenses: expensesMap[project.projectId] ?? [],
      );
    }).toList();
  }

  double get allocatedAmount => _totalAllocatedAmount;
  double get spentAmount => _spentAmount;
  List<ProjectModel> get projects => _projects;

  List<ProjectWithBudget> get projectsWithBudget => _projectsWithBudget;
  List<AddExpenseModel> get expenses => _expenses;
  UserModel? get user => _userController.user;
}
