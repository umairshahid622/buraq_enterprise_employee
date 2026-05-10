import 'package:buraq_enterprise_employee/core/controllers/base_controller.dart';
import 'package:buraq_enterprise_employee/core/controllers/user_controller.dart';
import 'package:buraq_enterprise_employee/data/common/allocated_amount_repository.dart';
import 'package:buraq_enterprise_employee/data/common/project_member_repository.dart';
import 'package:buraq_enterprise_employee/data/screens/project_repository.dart';
import 'package:buraq_enterprise_employee/models/allocated_amount_model.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:get/get.dart';

class HomeScreenController extends BaseController {
  //repositories
  final AllocatedAmountRepository _allocatedAmountRepository =
      AllocatedAmountRepository();
  final ProjectMemberRepository _projectMemberRepository =
      ProjectMemberRepository();
  final ProjectRepository _projectRepo = ProjectRepository();
  //controllers
  final UserController _userController = Get.find<UserController>();

  //variables
  double _totalAllocatedAmount = 0.0;
  double _spentAmount = 0.0;

  //Lists
   List<ProjectModel> _projects = [];
   List<AllocatedAmountModel> _allocatedAmounts = [];

  @override
  void onInit() {
    super.onInit();
    fetchHomeScreenData();
  }

  Future<void> fetchHomeScreenData() async {
    final empId = _userController.user?.empId;
    if (empId == null || empId.isEmpty) return;

    final results = await safeCall(
      () => Future.wait([
        _allocatedAmountRepository.getAllocatedAmount(employeeId: empId),
        _fetchProjects(empId)
      ]),
    );

    if (results != null) {
      final (list, total) = results[0] as (List<AllocatedAmountModel>, double);
      _allocatedAmounts = list;
      _totalAllocatedAmount = total;
      _projects = results[1] as List<ProjectModel>;
      update();
    }
  }

  Future<List<ProjectModel>> _fetchProjects(String empId) async {
    final projectIds = await _projectMemberRepository.getProjectIds(empId);
    if (projectIds.isEmpty) return [];
    return _projectRepo.getProjectsByIds(projectIds: projectIds);
  }

  double get allocatedAmount => _totalAllocatedAmount;
  double get spentAmount => _spentAmount;
  List<ProjectModel> get projects => _projects;
  List<AllocatedAmountModel> get allocatedAmounts => _allocatedAmounts;
}
