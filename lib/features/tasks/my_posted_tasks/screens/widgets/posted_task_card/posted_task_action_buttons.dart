import 'package:flutter/material.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';
import 'package:tasklink/models/tasks/task_model.dart';

class PostedTaskActionButtons extends StatelessWidget {
  final TaskModel task;
  final bool isTasker;
  final VoidCallback? onMessageTasker;
  final VoidCallback? onMessagePoster;
  final VoidCallback? onMarkTaskComplete;
  final VoidCallback? onTrackStatus;
  final VoidCallback? onMarkCompletion;
  final VoidCallback? onGiveFeedback;
  final VoidCallback? onViewDispute;

  const PostedTaskActionButtons({
    super.key,
    required this.task,
    required this.isTasker,
    this.onMessageTasker,
    this.onMessagePoster,
    this.onMarkTaskComplete,
    this.onTrackStatus,
    this.onMarkCompletion,
    this.onGiveFeedback,
    this.onViewDispute,
  });

  static bool shouldShowActionButtons(TaskModel task) {
    switch (task.status) {
      case 'ASSIGNED':
      case 'IN_PROGRESS':
      case 'COMPLETED':
      case 'CONFIRMED':
      case 'DISPUTED':
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (task.status) {
      case 'ASSIGNED':
      case 'IN_PROGRESS':
        if (isTasker) {
          return Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  onPressed: onMessagePoster ?? onMessageTasker,
                  text: 'Message',
                  icon: Icons.chat_bubble_outline,
                  height: 40,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  onPressed: onMarkTaskComplete,
                  text: 'Deliver',
                  icon: Icons.check_circle_outline,
                  height: 40,
                  fontSize: 13,
                ),
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onPressed: onMessageTasker,
                text: 'Chat',
                icon: Icons.chat_bubble_outline,
                height: 40,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SecondaryButton(
                onPressed: onTrackStatus ?? () {},
                text: 'Track Status',
                icon: Icons.track_changes,
                height: 40,
                fontSize: 13,
              ),
            ),
          ],
        );
      case 'COMPLETED':
        // Delivered: tasker can Message + Raise Dispute; poster can Complete + Dispute
        if (isTasker) {
          return Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  onPressed: onMessagePoster ?? onMessageTasker,
                  text: 'Message',
                  icon: Icons.chat_bubble_outline,
                  height: 40,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  onPressed: onViewDispute,
                  text: 'Raise Dispute',
                  icon: Icons.warning_amber_rounded,
                  height: 40,
                  fontSize: 13,
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onPressed: onMarkCompletion,
                text: 'Complete',
                icon: Icons.check_circle_outline,
                height: 40,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SecondaryButton(
                onPressed: onViewDispute,
                text: 'Dispute',
                icon: Icons.warning_amber_rounded,
                height: 40,
                fontSize: 13,
              ),
            ),
          ],
        );
      case 'CONFIRMED':
        return PrimaryButton(
          onPressed: onGiveFeedback,
          text: 'Give Feedback',
          icon: Icons.star_rate_rounded,
          height: 40,
          fontSize: 13,
        );
      case 'DISPUTED':
        // Both poster and tasker: View Dispute + Chat
        return Row(
          children: [
            Expanded(
              child: SecondaryButton(
                showBorder: false,
                onPressed: onViewDispute,
                text: 'View Dispute',
                icon: Icons.warning_amber_rounded,
                height: 40,
                fontSize: 13,
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red[900],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SecondaryButton(
                onPressed: onMessagePoster ?? onMessageTasker,
                text: 'Chat',
                icon: Icons.chat_bubble_outline,
                height: 40,
                fontSize: 13,
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
