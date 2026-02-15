import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/controllers/features/tasks/tasks_controller.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_task_card.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_tasks_tabs.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/models/tasks/task_model.dart';

class MyPostedTasksScreen extends StatefulWidget {
  const MyPostedTasksScreen({super.key});

  @override
  State<MyPostedTasksScreen> createState() => _MyPostedTasksScreenState();
}

class _MyPostedTasksScreenState extends State<MyPostedTasksScreen> {
  String _activeTab = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(TasksController());

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1a1a0b) : Colors.white,
      appBar: PrimaryAppBar(
        title: 'My Tasks',
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: TColors.primary,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                await Get.toNamed(Routes.POST_TASK);
                controller.fetchTasks();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Obx(() {
            final taskCounts = _calculateTaskCounts(controller.allTasks);
            return PostedTasksTabs(
              activeTab: _activeTab,
              taskCounts: taskCounts,
              onTabSelected: (tab) {
                setState(() {
                  _activeTab = tab;
                });
              },
            );
          }),

          // Task List
          Expanded(
            child: Container(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey[50],
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: TColors.primary),
                  );
                }

                final filteredTasks = _filterTasks(controller.allTasks);

                if (filteredTasks.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshTasks,
                  color: TColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return PostedTaskCard(
                        task: task,
                        onMessageTasker: () => _handleMessageTasker(task),
                        onTrackStatus: () => _handleTrackStatus(task),
                        onMarkCompletion: () => _handleMarkCompletion(task),
                        onGiveFeedback: () => _handleGiveFeedback(task),
                        onViewDispute: () => _handleViewDispute(task),
                        onEdit: () => _handleEditTask(task),
                        onDelete: () => _handleDeleteTask(task),
                        onTap: () => _handleTaskTap(task),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    switch (_activeTab) {
      case 'All':
        return tasks;
      case 'Bidding':
        return tasks
            .where(
              (task) => task.status == 'POSTED' || task.status == 'BIDDING',
            )
            .toList();
      case 'Assigned':
        return tasks.where((task) => task.status == 'ASSIGNED').toList();

      case 'Delivered':
        return tasks.where((task) => task.status == 'COMPLETED').toList();
      case 'Completed':
        return tasks.where((task) => task.status == 'CONFIRMED').toList();
      case 'Disputed':
        return tasks.where((task) => task.status == 'DISPUTED').toList();
      case 'Cancelled':
        return tasks.where((task) => task.status == 'CANCELLED').toList();
      default:
        return tasks;
    }
  }

  Map<String, int> _calculateTaskCounts(List<TaskModel> tasks) {
    return {
      'All': tasks.length,
      'Bidding': tasks
          .where((task) => task.status == 'POSTED' || task.status == 'BIDDING')
          .length,
      'Assigned': tasks.where((task) => task.status == 'ASSIGNED').length,
      'Delivered': tasks.where((task) => task.status == 'COMPLETED').length,
      'Completed': tasks.where((task) => task.status == 'CONFIRMED').length,
      'Disputed': tasks.where((task) => task.status == 'DISPUTED').length,
      'Cancelled': tasks.where((task) => task.status == 'CANCELLED').length,
    };
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _activeTab == 'All'
                ? 'Post your first task to get started'
                : 'No tasks in $_activeTab',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTaskTap(TaskModel task) {
    // Navigate to task details screen with task ID for dynamic fetching
    Get.toNamed(Routes.TASK_DETAILS, arguments: {'taskId': task.id});
  }

  void _handleMessageTasker(TaskModel task) {
    if (task.assignedTasker != null) {
      Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {'taskId': task.id, 'otherUser': task.assignedTasker},
      );
    }
  }

  void _handleTrackStatus(TaskModel task) {
    Get.toNamed(Routes.DASHBOARD, arguments: {'taskId': task.id});
  }

  void _handleMarkCompletion(TaskModel task) {
    Get.toNamed(Routes.COMPLETE_RATINGS, arguments: {'taskId': task.id});
  }

  void _handleGiveFeedback(TaskModel task) {
    Get.toNamed(
      Routes.WRITE_REVIEW,
      arguments: {'taskId': task.id, 'revieweeId': task.assignedTasker?.id},
    );
  }

  void _handleViewDispute(TaskModel task) {
    Get.toNamed(Routes.DISPUTE, arguments: {'taskId': task.id});
  }

  void _handleEditTask(TaskModel task) {
    // Navigate to edit task screen (post task screen with task data)
    Get.toNamed(Routes.POST_TASK, arguments: {'task': task, 'isEdit': true});
  }

  void _handleDeleteTask(TaskModel task) {
    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Implement delete task API call
              // For now, just show a message
              Get.snackbar(
                'Delete Task',
                'Task deletion will be implemented',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
