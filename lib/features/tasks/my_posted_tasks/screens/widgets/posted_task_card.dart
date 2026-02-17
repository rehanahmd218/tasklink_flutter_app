import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/utils/formatters/date_formatter.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_task_card/posted_task_image.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_task_card/posted_task_options_menu.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_task_card/posted_task_status_badge.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/posted_task_card/posted_task_action_buttons.dart';

class PostedTaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isTasker;
  final VoidCallback? onMessageTasker;
  final VoidCallback? onMessagePoster;
  final VoidCallback? onMarkTaskComplete;
  final VoidCallback? onTrackStatus;
  final VoidCallback? onMarkCompletion;
  final VoidCallback? onGiveFeedback;
  final VoidCallback? onViewDispute;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewBids;

  const PostedTaskCard({
    super.key,
    required this.task,
    this.isTasker = false,
    this.onMessageTasker,
    this.onMessagePoster,
    this.onMarkTaskComplete,
    this.onTrackStatus,
    this.onMarkCompletion,
    this.onGiveFeedback,
    this.onViewDispute,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onViewBids,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2c2c1a) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                PostedTaskImage(task: task, isDark: isDark),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : TColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isTasker)
                            PostedTaskOptionsMenu(
                              isDark: isDark,
                              canEdit: task.status == 'POSTED' ||
                                  task.status == 'BIDDING',
                              onEdit: onEdit,
                              onDelete: onDelete,
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            formatTimeAgo(task.createdAt),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: TColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            task.category,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: TColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.addressText,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: TColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatCurrency(task.budget),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.grey[200]
                                  : TColors.textPrimary,
                            ),
                          ),
                          PostedTaskStatusBadge(task: task, isDark: isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (PostedTaskActionButtons.shouldShowActionButtons(task)) ...[
              const SizedBox(height: 12),
              PostedTaskActionButtons(
                task: task,
                isTasker: isTasker,
                onMessageTasker: onMessageTasker,
                onMessagePoster: onMessagePoster,
                onMarkTaskComplete: onMarkTaskComplete,
                onTrackStatus: onTrackStatus,
                onMarkCompletion: onMarkCompletion,
                onGiveFeedback: onGiveFeedback,
                onViewDispute: onViewDispute,
              ),
            ],
            if (task.status == 'BIDDING' && task.bidCount > 0) ...[
              const SizedBox(height: 12),
              PrimaryButton(
                onPressed: onViewBids ?? onTap,
                text:
                    'View ${task.bidCount} ${task.bidCount == 1 ? 'Bid' : 'Bids'}',
                icon: Icons.gavel,
                height: 40,
                fontSize: 13,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
