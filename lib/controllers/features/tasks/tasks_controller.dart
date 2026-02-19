import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/services/tasks/task_service.dart';

/// Tasks Controller
///
/// Manages all tasks with role-based filtering and status filtering
class TasksController extends GetxController {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final TaskService _taskService = TaskService();
  final UserController _userController = UserController.instance;

  // All tasks list
  final RxList<TaskModel> allTasks = <TaskModel>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Current filter (default: Active = tasks in progress, i.e. not CONFIRMED)
  final RxString currentFilter = 'Active'.obs;

  // Filtered tasks based on current filter.
  // 'All' and 'Active' are handled in fetchTasks (allTasks is already the right list).
  // 'Active' = all statuses except CONFIRMED; backend has no single 'ACTIVE' status.
  List<TaskModel> get filteredTasks {
    final filter = currentFilter.value;
    if (filter == 'All' || filter == 'Active') {
      return allTasks;
    }
    return allTasks
        .where((task) => task.status == filter.toUpperCase())
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  /// Apply filter and fetch tasks (called from filter bottom sheet "Apply")
  Future<void> applyFilter(String filter) async {
    currentFilter.value = filter;
    _log.i('Filter applied: $filter');
    await fetchTasks();
  }

  /// Fetch tasks based on user role and current filter (backend supports status query param)
  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      final userRole = _userController.currentUser.value?.role;
      _log.i(
        'Fetching tasks for role: $userRole, filter: ${currentFilter.value}',
      );

      final filter = currentFilter.value;
      String? apiStatus;
      bool filterClientSide = false;
      List<String>? clientStatuses;

      switch (filter) {
        case 'All':
          apiStatus = null;
          break;
        case 'Active':
          // Active = task in progress (any status except CONFIRMED)
          apiStatus = null;
          filterClientSide = true;
          clientStatuses = [
            'POSTED',
            'BIDDING',
            'ASSIGNED',
            'IN_PROGRESS',
            'COMPLETED',
            'CANCELLED',
            'DISPUTED',
          ];
          break;
        case 'Bidding':
          apiStatus = 'BIDDING';
          break;
        case 'Assigned':
          if (userRole == 'POSTER') {
            apiStatus = 'ASSIGNED';
          } else {
            apiStatus = null;
            filterClientSide = true;
            clientStatuses = ['ASSIGNED', 'IN_PROGRESS'];
          }
          break;
        case 'Delivered':
          apiStatus = 'COMPLETED';
          break;
        case 'Completed':
          apiStatus = 'CONFIRMED';
          break;
        case 'Disputed':
          apiStatus = 'DISPUTED';
          break;
        case 'Canceled':
        case 'Cancelled':
          apiStatus = 'CANCELLED';
          break;
        default:
          apiStatus = null;
      }

      List<TaskModel> tasks;
      if (userRole == 'POSTER') {
        tasks = await _taskService.getMyPostedTasks(status: apiStatus);
      } else {
        tasks = await _taskService.getTasksAssignedToMe(status: apiStatus);
      }

      if (filterClientSide && clientStatuses != null) {
        tasks = tasks
            .where((t) => clientStatuses!.contains(t.status))
            .toList();
      }

      allTasks.value = tasks;
      _log.i('Fetched ${tasks.length} tasks');
    } catch (e) {
      _log.e('Error fetching tasks: $e');
      allTasks.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Reload tasks when role changes
  Future<void> reloadForRoleChange() async {
    _log.i('Reloading tasks due to role change');
    allTasks.clear();
    currentFilter.value = 'Active';
    await fetchTasks();
  }

  /// Refresh tasks
  Future<void> refreshTasks() async {
    try {
      isRefreshing.value = true;
      await fetchTasks();
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Set filter and update filtered tasks
  void setFilter(String filter) {
    currentFilter.value = filter;
    _log.i('Filter changed to: $filter');
  }

  /// Get tasks by specific status
  List<TaskModel> getTasksByStatus(String status) {
    if (status == 'All') {
      return allTasks;
    }
    return allTasks
        .where((task) => task.status == status.toUpperCase())
        .toList();
  }

  /// Get count of tasks by status
  int getTaskCountByStatus(String status) {
    if (status == 'All') {
      return allTasks.length;
    }
    return allTasks.where((task) => task.status == status.toUpperCase()).length;
  }
}
