import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/services/tasks/task_service.dart';

enum TaskRole { poster, tasker }

class TaskDetailsController extends GetxController {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final UserController _userController = UserController.instance;
  final TaskService _taskService = TaskService();

  final Rx<TaskModel?> currentTask = Rx<TaskModel?>(null);
  final userRole = Rx<TaskRole>(TaskRole.tasker);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Fetch task by ID from backend
  Future<void> fetchTaskById(String taskId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      _log.i('Fetching task details for ID: $taskId');

      final task = await _taskService.getTaskById(taskId);
      currentTask.value = task;
      _determineRole();

      _log.i('Task fetched successfully: ${task.title}');
    } catch (e) {
      _log.e('Error fetching task: $e');
      errorMessage.value = e.toString();
      StatusSnackbar.showError(message: 'Failed to load task details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Set the current task and determine the role (for when task is already available)
  void setTask(TaskModel task) {
    currentTask.value = task;
    _determineRole();
  }

  /// Manually set role (for demo purposes)
  void setRole(TaskRole role) {
    userRole.value = role;
  }

  /// Determine user role based on current user and task poster
  void _determineRole() {
    final currentUser = _userController.currentUser.value;
    final task = currentTask.value;

    if (currentUser == null || task == null) {
      userRole.value = TaskRole.tasker;
      return;
    }

    // If current user is the poster of this task, set role to poster
    if (task.poster?.id == currentUser.id) {
      userRole.value = TaskRole.poster;
    } else {
      userRole.value = TaskRole.tasker;
    }
  }

  /// Check if current user is the owner of the task
  bool get isTaskOwner {
    final currentUser = _userController.currentUser.value;
    final task = currentTask.value;

    if (currentUser == null || task == null) return false;

    return task.poster?.id == currentUser.id;
  }

  /// Check if user can place a bid (is a tasker and not the owner)
  bool get canPlaceBid {
    final currentUser = _userController.currentUser.value;
    final task = currentTask.value;

    if (currentUser == null || task == null) return false;

    // User can place bid if they are not the poster and task is in BIDDING status
    return task.poster?.id != currentUser.id &&
        task.status == 'BIDDING' &&
        (currentUser.role == 'TASKER' || currentUser.role == 'BOTH');
  }

  /// Task is open for bids (not owner, BIDDING) but user's role is POSTER — show "Switch to Tasker to apply"
  bool get shouldShowSwitchToTaskerToBid {
    final currentUser = _userController.currentUser.value;
    final task = currentTask.value;

    if (currentUser == null || task == null) return false;

    return task.poster?.id != currentUser.id &&
        task.status == 'BIDDING' &&
        currentUser.role == 'POSTER';
  }

  /// Check if user can edit/delete (is poster, owns the task, and status is POSTED or BIDDING)
  bool get canEditDelete {
    if (!isTaskOwner || userRole.value != TaskRole.poster) return false;
    final task = currentTask.value;
    if (task == null) return false;
    return task.status == 'POSTED' || task.status == 'BIDDING';
  }

  /// Check if current user is the assigned tasker and task is in ASSIGNED or IN_PROGRESS (show Deliver + Cancel footer)
  bool get canShowTaskerAssignedActions {
    final currentUser = _userController.currentUser.value;
    final task = currentTask.value;
    if (currentUser == null || task == null) return false;
    if (task.poster?.id == currentUser.id) return false;
    final isAssignedToMe = task.assignedTasker?.id == currentUser.id;
    final statusOk = task.status == 'ASSIGNED' || task.status == 'IN_PROGRESS';
    return isAssignedToMe && statusOk;
  }
}
