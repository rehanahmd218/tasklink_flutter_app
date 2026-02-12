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

  // Current filter
  final RxString currentFilter = 'All'.obs;

  // Filtered tasks based on current filter
  List<TaskModel> get filteredTasks {
    if (currentFilter.value == 'All') {
      return allTasks;
    }
    return allTasks
        .where((task) => task.status == currentFilter.value.toUpperCase())
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  /// Fetch tasks based on user role
  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      _log.i(
        'Fetching tasks for user role: ${_userController.currentUser.value?.role}',
      );

      final userRole = _userController.currentUser.value?.role;

      List<TaskModel> tasks;

      if (userRole == 'POSTER') {
        // Fetch tasks posted by the user
        tasks = await _taskService.getMyPostedTasks();
      } else {
        // Fetch tasks assigned to the user (TASKER or BOTH)
        tasks = await _taskService.getTasksAssignedToMe();
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
