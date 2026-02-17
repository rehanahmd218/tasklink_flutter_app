import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/controllers/features/tasks/task_details_controller.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_details_header.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_status_banner.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_poster_profile.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_meta_grid.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_location_display.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_media_gallery.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_description_section.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_details_place_bid_footer.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_details_edit_delete_footer.dart';
import 'package:tasklink/features/tasks/task_details/widgets/task_details_tasker_assigned_footer.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/services/tasks/task_service.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel? task;
  final String? taskId;

  const TaskDetailsScreen({super.key, this.task, this.taskId})
    : assert(
        task != null || taskId != null,
        'Either task or taskId must be provided',
      );

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late final TaskDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TaskDetailsController());

    // If task object is provided, use it directly
    if (widget.task != null) {
      controller.setTask(widget.task!);
    }
    // Otherwise, fetch task by ID
    else if (widget.taskId != null) {
      controller.fetchTaskById(widget.taskId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Task Details',
        actions: [
          Obx(() {
            // Show edit icon only if user is poster and owns the task
            if (controller.canEditDelete) {
              return IconButton(
                onPressed: _handleEdit,
                icon: const Icon(Icons.edit),
              );
            }
            // Show share icon for others
            return IconButton(
              onPressed: _handleShare,
              icon: const Icon(Icons.share),
            );
          }),
        ],
      ),
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Failed to load task',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    if (widget.taskId != null) {
                      controller.fetchTaskById(widget.taskId!);
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }

        // Show task details
        final task = controller.currentTask.value;
        if (task == null) {
          return const Center(child: Text('No task data available'));
        }

        return _buildTaskDetails(task);
      }),
    );
  }

  Widget _buildTaskDetails(TaskModel task) {
    return Obx(() {
      final role = controller.userRole.value;
      final isOwner = controller.isTaskOwner;

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Banner (Poster Only - if owner)
                  if (role == TaskRole.poster && isOwner)
                    TaskStatusBanner(task: task),

                  // Header (Title, Budget, Posted Time)
                  TaskDetailsHeader(task: task, isOwner: isOwner),

                  // Poster Profile (Always show)
                  _buildPosterProfile(task, isOwner),

                  // Meta Grid (Date & Time, Category)
                  TaskMetaGrid(task: task),

                  // Location
                  TaskLocationDisplay(task: task),

                  // Task Media Gallery
                  if (task.media.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    TaskMediaGallery(media: task.media),
                  ],

                  // Description
                  TaskDescriptionSection(task: task),

                  // Safe Payments Warning
                  _buildSafePaymentsWarning(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Sticky Footer
          _buildFooter(task),
        ],
      );
    });
  }

  Widget _buildPosterProfile(TaskModel task, bool isOwner) {
    if (task.poster == null) return const SizedBox.shrink();
    print(task.poster!.displayName);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TaskPosterProfile(
        name: task.poster!.displayName,
        avatarUrl: task.poster!.profileImage ?? '',
        rating: task.poster!.ratingAvg,
        reviews: task.poster!.reviewsCount,
        onTap: () => _handleProfileTap(task, isOwner),
      ),
    );
  }

  Widget _buildSafePaymentsWarning() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.security, color: Colors.blue.shade700, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safe Payments',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Payment is held securely until the task is completed. Never pay outside the app.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.blue.shade800,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(TaskModel task) {
    return Obx(() {
      // Tasker assigned: Deliver + Cancel
      if (controller.canShowTaskerAssignedActions) {
        return TaskDetailsTaskerAssignedFooter(
          onDeliver: () => _handleDeliver(task),
          onCancel: () => _handleTaskerCancel(task),
        );
      }

      // Show Place Bid button if user can place bid
      if (controller.canPlaceBid) {
        return TaskDetailsPlaceBidFooter(
          task: task,
          onPlaceBid: _handlePlaceBid,
        );
      }

      // Show Edit/Delete buttons if user owns the task
      if (controller.canEditDelete) {
        return TaskDetailsEditDeleteFooter(
          onEdit: _handleEdit,
          onDelete: _handleDelete,
        );
      }

      return const SizedBox.shrink();
    });
  }

  Future<void> _handleDeliver(TaskModel task) async {
    try {
      FullScreenLoader.show(text: 'Marking as delivered...');
      await TaskService().markTaskCompleted(task.id);
      FullScreenLoader.hide();
      controller.fetchTaskById(task.id);
      Get.snackbar('Success', 'Task marked as delivered. Waiting for poster confirmation.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  Future<void> _handleTaskerCancel(TaskModel task) async {
    try {
      FullScreenLoader.show(text: 'Cancelling...');
      await TaskService().cancelTask(task.id);
      FullScreenLoader.hide();
      controller.fetchTaskById(task.id);
      Get.snackbar('Success', 'Task cancelled.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      FullScreenLoader.hide();
      // Backend may return 403 for tasker; show message
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  void _handleProfileTap(TaskModel task, bool isOwner) {
    if (isOwner) {
      // Navigate to own profile
      Get.toNamed(Routes.PROFILE);
    } else {
      // Navigate to poster's public profile
      // TODO: Implement public profile view
      Get.snackbar(
        'View Profile',
        'Navigate to ${task.poster!.displayName}\'s profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _handlePlaceBid() {
    final task = controller.currentTask.value;
    if (task != null) {
      Get.toNamed(Routes.PLACE_BID, arguments: task);
    }
  }

  void _handleEdit() {
    final task = controller.currentTask.value;
    if (task != null) {
      Get.toNamed(Routes.POST_TASK, arguments: task);
    }
  }

  void _handleDelete() {
    final task = controller.currentTask.value;
    if (task == null) return;

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
              Get.back(); // Close dialog
              Get.put(PostTaskController()).deleteTask(task.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleShare() {
    // TODO: Implement share functionality
    Get.snackbar(
      'Share',
      'Share functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
