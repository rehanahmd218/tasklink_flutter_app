import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/controllers/features/tasks/my_posted_tasks_controller.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/controllers/features/tasks/tasks_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/bids/bids_tasker_view/widgets/my_bid_card.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_task_card.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_tasks_tabs.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/task_filter_bar.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/tasks_bids_segmented_control.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/tasks_empty_state_with_refresh.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/services/disputes/dispute_service.dart';
import 'package:tasklink/services/tasks/task_service.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';

class MyPostedTasksScreen extends StatefulWidget {
  const MyPostedTasksScreen({super.key});

  @override
  State<MyPostedTasksScreen> createState() => _MyPostedTasksScreenState();
}

class _MyPostedTasksScreenState extends State<MyPostedTasksScreen> {
  @override
  void initState() {
    super.initState();
    // Reuse existing controllers when returning to this screen so filter/tab state is preserved
    if (!Get.isRegistered<TasksController>()) {
      Get.put(TasksController());
    }
    if (!Get.isRegistered<BidController>()) {
      Get.put(BidController());
    }
    if (!Get.isRegistered<MyPostedTasksController>()) {
      Get.put(MyPostedTasksController());
    }
  }

  @override
  void dispose() {
    // Do not delete controllers on dispose so filter/tab state is preserved when switching screens
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final controller = Get.find<TasksController>();
    final uiController = Get.find<MyPostedTasksController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final userRole = userController.currentUser.value?.role;
      final isPoster = userRole == 'POSTER';
      final screenTitle = isPoster ? 'Posted Tasks' : 'Assigned Tasks';
      // Only track role for UI; do not auto-refresh when switching tabs.
      // Data loads from TasksController.onInit and manual pull-to-refresh only.
      if (uiController.shouldReloadForRole(userRole)) {
        uiController.markRoleLoaded(userRole);
        controller.setFilter('Active');
      }

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF1a1a0b) : Colors.white,
        appBar: PrimaryAppBar(
          title: screenTitle,
          showBackButton: false,
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
            if (isPoster)
              const TaskFilterBar()
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Obx(() => TasksBidsSegmentedControl(
                          isTasksSelected: uiController.taskerSectionIsTasks.value,
                          onSelected: uiController.setTaskerSection,
                        )),
                  ),
                  Obx(() {
                    final bidController = Get.find<BidController>();
                    if (uiController.taskerSectionIsTasks.value) {
                      return const TaskFilterBar();
                    }
                    final bidCounts =
                        uiController.taskerBidCounts(bidController.myBids);
                    return Obx(() => PostedTasksTabs(
                          activeTab: uiController.taskerBidsSubTab.value,
                          tabs: MyPostedTasksController.taskerBidsTabs,
                          taskCounts: bidCounts,
                          onTabSelected: uiController.setBidsSubTab,
                        ));
                  }),
                ],
              ),

            Expanded(
              child: Container(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey[50],
                child: _buildBody(
                  controller,
                  uiController,
                  isPoster,
                  isDark,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBody(
    TasksController controller,
    MyPostedTasksController uiController,
    bool isPoster,
    bool isDark,
  ) {
    if (!isPoster && !uiController.taskerSectionIsTasks.value) {
      return Obx(() {
        final bidController = Get.find<BidController>();
        if (bidController.isLoadingBids.value) {
          return const Center(
            child: CircularProgressIndicator(color: TColors.primary),
          );
        }
        final filteredBids = uiController.filterBidsForTasker(
          bidController.myBids,
          uiController.taskerBidsSubTab.value,
        );
        if (filteredBids.isEmpty) {
          return TasksEmptyStateWithRefresh(
            isDark: isDark,
            filterLabel: uiController.taskerBidsSubTab.value,
            onRefresh: () async {
              await controller.refreshTasks();
              bidController.fetchMyBids();
            },
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshTasks();
            bidController.fetchMyBids();
          },
          color: TColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredBids.length,
            itemBuilder: (context, index) {
              final bid = filteredBids[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MyBidCard(
                  bid: bid,
                  onViewTask: () => Get.toNamed(
                    Routes.TASK_DETAILS,
                    arguments: {'taskId': bid.task},
                  ),
                  onEditBid: () => _handleEditBid(bid),
                  onDeleteBid: () => _handleDeleteBid(bid),
                ),
              );
            },
          ),
        );
      });
    }

    if (!isPoster && uiController.taskerSectionIsTasks.value) {
      return Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: TColors.primary),
          );
        }
        final tasks = controller.filteredTasks;
        final filterLabel = controller.currentFilter.value;
        if (tasks.isEmpty) {
          return TasksEmptyStateWithRefresh(
            isDark: isDark,
            filterLabel: filterLabel,
            onRefresh: controller.refreshTasks,
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refreshTasks,
          color: TColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return PostedTaskCard(
                task: task,
                isTasker: true,
                onMessageTasker: () => _handleMessageTasker(task),
                onMessagePoster: () => _handleMessagePoster(task),
                onMarkTaskComplete: () => _handleMarkTaskComplete(task),
                onTrackStatus: () => _handleTrackStatus(task),
                onMarkCompletion: () => _handleMarkCompletion(task),
                onGiveFeedback: () => _handleGiveFeedback(task),
                onViewDispute: () => _handleViewDispute(task, isPoster: false),
                onEdit: () => _handleEditTask(task),
                onDelete: () => _handleDeleteTask(task),
                onTap: () => _handleTaskTap(task),
                onViewBids: () => _handleViewBids(task),
              );
            },
          ),
        );
      });
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: TColors.primary),
        );
      }
      final tasks = controller.filteredTasks;
      final filterLabel = controller.currentFilter.value;
      if (tasks.isEmpty) {
        return TasksEmptyStateWithRefresh(
          isDark: isDark,
          filterLabel: filterLabel,
          onRefresh: controller.refreshTasks,
        );
      }
      return RefreshIndicator(
        onRefresh: controller.refreshTasks,
        color: TColors.primary,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return PostedTaskCard(
              task: task,
              isTasker: false,
              onMessageTasker: () => _handleMessageTasker(task),
              onMessagePoster: () => _handleMessagePoster(task),
              onMarkTaskComplete: () => _handleMarkTaskComplete(task),
              onTrackStatus: () => _handleTrackStatus(task),
              onMarkCompletion: () => _handleMarkCompletion(task),
              onGiveFeedback: () => _handleGiveFeedback(task),
              onViewDispute: () => _handleViewDispute(task, isPoster: true),
              onEdit: () => _handleEditTask(task),
              onDelete: () => _handleDeleteTask(task),
              onTap: () => _handleTaskTap(task),
              onViewBids: () => _handleViewBids(task),
            );
          },
        ),
      );
    });
  }

  Future<void> _handleEditBid(BidModel bid) async {
    
    final task = TaskModel(
      id: bid.task,
      title: bid.taskTitle ?? 'Task',
      description: '',
      category: '',
      budget: 0,
      status: '',
      paymentVerified: false,
      addressText: '',
      radius: 0,
      createdAt: bid.createdAt,
    );
    final result = await Get.toNamed(
      Routes.PLACE_BID,
      arguments: {'task': task, 'bid': bid},
    );
    if (result == true) Get.find<BidController>().fetchMyBids();
  }

  void _handleDeleteBid(BidModel bid) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Bid'),
        content: const Text(
          'Are you sure you want to withdraw this bid?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await Get.find<BidController>().withdrawBid(bid.id, popAfter: false);
              Get.find<BidController>().fetchMyBids();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
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

  void _handleMessagePoster(TaskModel task) {
    if (task.poster != null) {
      Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {'taskId': task.id, 'otherUser': task.poster},
      );
    }
  }

  Future<void> _handleMarkTaskComplete(TaskModel task) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Mark as complete'),
        content: const Text(
          'Are you sure you want to mark this task as completed? The poster will be asked to confirm.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      FullScreenLoader.show(text: 'Marking complete...');
      await TaskService().markTaskCompleted(task.id);
      FullScreenLoader.hide();
      Get.find<TasksController>().refreshTasks();
      StatusSnackbar.showSuccess(message: 'Task marked as complete');
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  void _handleTrackStatus(TaskModel task) {
    Get.toNamed(Routes.DASHBOARD, arguments: {'taskId': task.id});
  }

  Future<void> _handleMarkCompletion(TaskModel task) async {
    try {
      FullScreenLoader.show(text: 'Confirming completion...');
      await TaskService().confirmTaskCompletion(task.id);
      FullScreenLoader.hide();
      Get.find<TasksController>().refreshTasks();
      StatusSnackbar.showSuccess(message: 'Completion confirmed. Payment released to tasker.');
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  void _handleGiveFeedback(TaskModel task) {
    Get.toNamed(
      Routes.WRITE_REVIEW,
      arguments: {'taskId': task.id, 'revieweeId': task.assignedTasker?.id},
    );
  }

  Future<void> _handleViewDispute(TaskModel task, {required bool isPoster}) async {
    try {
      final existing = await DisputeService().getDisputeByTask(task.id);
      if (existing != null) {
        Get.toNamed(Routes.DISPUTE_STATUS, arguments: {'disputeId': existing.id});
      } else {
        Get.toNamed(Routes.DISPUTE, arguments: {'taskId': task.id, 'isPoster': isPoster});
      }
    } catch (_) {
      Get.toNamed(Routes.DISPUTE, arguments: {'taskId': task.id, 'isPoster': isPoster});
    }
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
