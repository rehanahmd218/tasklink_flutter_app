import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/controllers/features/tasks/tasks_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_task_card.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_tasks_tabs.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/utils/constants/colors.dart';

class MyPostedTasksScreen extends StatefulWidget {
  const MyPostedTasksScreen({super.key});

  @override
  State<MyPostedTasksScreen> createState() => _MyPostedTasksScreenState();
}

class _MyPostedTasksScreenState extends State<MyPostedTasksScreen> {
  String _activeTab = 'All';

  @override
  void initState() {
    super.initState();
    // Re-fetch tasks whenever the screen is initialized
    final controller = Get.put(TasksController());
    controller.refreshTasks();
  }

  @override
  void dispose() {
    // Ensure controller is cleared to force re-initialization on next visit
    Get.delete<TasksController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final controller = Get.put(TasksController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final userRole = userController.currentUser.value?.role;
      final isPoster = userRole == 'POSTER';
      final tabs = _getTabsForRole(isPoster);
      final screenTitle = isPoster ? 'Posted Tasks' : 'Assigned Tasks';

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF1a1a0b) : Colors.white,
        appBar: PrimaryAppBar(
          title: screenTitle,
          actions: [
            if (isPoster)
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
              // If current tab is not in the new tabs list (e.g. role switch), reset to All
              if (!tabs.contains(_activeTab)) {
                // We need to schedule this to avoid build errors or just handle it gracefully
                // Using Future.microtask might be safe but stateless widgets inside Obx are safer.
                // Here we just use 'All' for logic if mismatch occurs, or reset.
                // Best to reset in the parent Obx? No, setState during build is bad.
                // We'll just default to 'All' in filtering if not found.
              }

              final taskCounts = _calculateTaskCounts(
                controller.allTasks,
                isPoster,
              );
              return PostedTasksTabs(
                activeTab: tabs.contains(_activeTab) ? _activeTab : 'All',
                tabs: tabs,
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

                  // Ensure we use a valid tab for filtering
                  final currentTab = tabs.contains(_activeTab)
                      ? _activeTab
                      : 'All';

                  final filteredTasks = _filterTasks(
                    controller.allTasks,
                    isPoster,
                    currentTab,
                  );

                  if (filteredTasks.isEmpty) {
                    return _buildEmptyState(isDark, currentTab);
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
                          onViewBids: () => _handleViewBids(task),
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
    });
  }

  List<String> _getTabsForRole(bool isPoster) {
    if (isPoster) {
      return [
        'All',
        'Bidding',
        'Assigned',
        'Delivered',
        'Completed',
        'Disputed',
        'Cancelled',
      ];
    } else {
      return [
        'All',
        'In Progress', // Maps to ASSIGNED/IN_PROGRESS
        'Applied', // Maps to BIDDING/POSTED
        'Delivered', // Maps to COMPLETED
        'Completed', // Maps to CONFIRMED
        'Canceled', // Maps to CANCELLED
        'Disputed', // Maps to DISPUTED
      ];
    }
  }

  List<TaskModel> _filterTasks(
    List<TaskModel> tasks,
    bool isPoster,
    String activeTab,
  ) {
    if (isPoster) {
      switch (activeTab) {
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
    } else {
      // Tasker Filtering
      switch (activeTab) {
        case 'All':
          return tasks;
        case 'In Progress':
          return tasks
              .where(
                (task) =>
                    task.status == 'ASSIGNED' || task.status == 'IN_PROGRESS',
              )
              .toList();
        case 'Applied':
          return tasks
              .where(
                (task) => task.status == 'POSTED' || task.status == 'BIDDING',
              )
              .toList();
        case 'Delivered':
          return tasks.where((task) => task.status == 'COMPLETED').toList();
        case 'Completed':
          return tasks.where((task) => task.status == 'CONFIRMED').toList();
        case 'Canceled':
          return tasks.where((task) => task.status == 'CANCELLED').toList();
        case 'Disputed':
          return tasks.where((task) => task.status == 'DISPUTED').toList();
        default:
          return tasks;
      }
    }
  }

  Map<String, int> _calculateTaskCounts(List<TaskModel> tasks, bool isPoster) {
    if (isPoster) {
      return {
        'All': tasks.length,
        'Bidding': tasks
            .where(
              (task) => task.status == 'POSTED' || task.status == 'BIDDING',
            )
            .length,
        'Assigned': tasks.where((task) => task.status == 'ASSIGNED').length,
        'Delivered': tasks.where((task) => task.status == 'COMPLETED').length,
        'Completed': tasks.where((task) => task.status == 'CONFIRMED').length,
        'Disputed': tasks.where((task) => task.status == 'DISPUTED').length,
        'Cancelled': tasks.where((task) => task.status == 'CANCELLED').length,
      };
    } else {
      return {
        'All': tasks.length,
        'In Progress': tasks
            .where(
              (task) =>
                  task.status == 'ASSIGNED' || task.status == 'IN_PROGRESS',
            )
            .length,
        'Applied': tasks
            .where(
              (task) => task.status == 'POSTED' || task.status == 'BIDDING',
            )
            .length,
        'Delivered': tasks.where((task) => task.status == 'COMPLETED').length,
        'Completed': tasks.where((task) => task.status == 'CONFIRMED').length,
        'Canceled': tasks.where((task) => task.status == 'CANCELLED').length,
        'Disputed': tasks.where((task) => task.status == 'DISPUTED').length,
      };
    }
  }

  Widget _buildEmptyState(bool isDark, String activeTab) {
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
            activeTab == 'All'
                ? 'No tasks found for your role'
                : 'No tasks in $activeTab',
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

  void _handleViewBids(TaskModel task) {
    // Navigate to bids poster view
    Get.toNamed(
      Routes.BIDS_POSTER,
      arguments: {'taskId': task.id, 'taskTitle': task.title},
    );
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
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await Get.put(PostTaskController()).deleteTask(task.id, popAfter: false);
              Get.find<TasksController>().refreshTasks();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
