import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/reviews/screens/widgets/review_rating_section.dart';
import 'package:tasklink/features/reviews/screens/widgets/review_tasker_info.dart';
import 'package:tasklink/features/reviews/screens/widgets/review_text_input.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/models/tasks/task_response_user_model.dart';
import 'package:tasklink/services/reviews/review_service.dart';
import 'package:tasklink/services/tasks/task_service.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  double _rating = 4.0;
  final TextEditingController _reviewController = TextEditingController();

  String? _taskId;
  TaskModel? _task;
  TaskResponseUserModel? _reviewee;
  bool _loading = true;
  String? _loadError;
  bool _submitting = false;

  static const String _placeholderAvatar =
      'https://ui-avatars.com/api/?name=User&size=96';

  @override
  void initState() {
    super.initState();
    _taskId = Get.arguments is Map ? Get.arguments['taskId']?.toString() : null;
    if (_taskId == null || _taskId!.isEmpty) {
      setState(() {
        _loading = false;
        _loadError = 'Task not specified.';
      });
      return;
    }
    _loadTask();
  }

  Future<void> _loadTask() async {
    try {
      final task = await TaskService().getTaskById(_taskId!);
      final currentUserId = UserController.instance.currentUser.value?.id;
      if (currentUserId == null) {
        setState(() {
          _loading = false;
          _loadError = 'You must be logged in to leave a review.';
        });
        return;
        }
      TaskResponseUserModel? reviewee;
      if (task.poster?.id == currentUserId) {
        reviewee = task.assignedTasker;
      } else {
        reviewee = task.poster;
      }
      if (reviewee == null) {
        setState(() {
          _loading = false;
          _loadError = 'Unable to determine who you are reviewing.';
        });
        return;
      }
      setState(() {
        _task = task;
        _reviewee = reviewee;
        _loading = false;
        _loadError = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _loadError = e is ValidationException ? e.message : 'Failed to load task.';
      });
    }
  }

  Future<void> _submitReview() async {
    if (_taskId == null || _task == null) return;
    setState(() => _submitting = true);
    try {
      await ReviewService().createReview(
        taskId: _taskId!,
        rating: _rating.round().clamp(1, 5),
        comment: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
      );
      Get.back(result: true);
      Get.snackbar('Success', 'Your review was submitted.');
    } catch (e) {
      String message = 'Could not submit review.';
      if (e is ValidationException) message = e.message;
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Write Review',
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? Colors.white : const Color(0xFF1c1c0d),
          ),
          onPressed: () => Get.back(),
        ),
        showBackButton: false,
      ),
      body: Stack(
        children: [
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_loadError != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _loadError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Go back'),
                    ),
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  ReviewTaskerInfo(
                    isDark: isDark,
                    imageUrl: _reviewee?.profileImage?.isNotEmpty == true
                        ? _reviewee!.profileImage!
                        : _placeholderAvatar,
                    taskerName: _reviewee?.displayName ?? 'User',
                    taskTitle: _task?.title ?? '',
                  ),
                  const SizedBox(height: 32),
                  ReviewRatingSection(
                    rating: _rating,
                    onRatingUpdate: (rating) {
                      setState(() => _rating = rating);
                    },
                  ),
                  const SizedBox(height: 32),
                  ReviewTextInput(
                    isDark: isDark,
                    controller: _reviewController,
                  ),
                ],
              ),
            ),
          if (!_loading && _loadError == null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
                  border: Border(
                    top: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                    ),
                  ),
                ),
                child: PrimaryButton(
                  onPressed: _submitting ? () {} : _submitReview,
                  text: _submitting ? 'Submitting...' : 'Submit Review',
                  icon: _submitting ? null : Icons.send,
                  isLoading: _submitting,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
