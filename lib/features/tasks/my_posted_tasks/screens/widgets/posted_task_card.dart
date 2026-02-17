import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../models/tasks/task_model.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/helpers/category_helper.dart';

class PostedTaskCard extends StatelessWidget {
  final TaskModel task;
  /// When true, card is shown in tasker's "Assigned Tasks" (e.g. Message poster + Complete for in-progress).
  final bool isTasker;
  final VoidCallback? onMessageTasker;
  final VoidCallback? onMessagePoster; // Tasker: chat with poster
  final VoidCallback? onMarkTaskComplete; // Tasker: mark task as completed
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
                // Task Image or Category Icon
                _buildTaskImage(isDark),
                const SizedBox(width: 16),
                // Task Details
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
                          if (!isTasker) _buildOptionsMenu(isDark),
                        ],
                      ),
                      // const SizedBox(height: 4),
                      // Time posted and Category (swapped with address)
                      Row(
                        children: [
                          Text(
                            '${formatTimeAgo(task.createdAt)}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: TColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Text(
                            task.category,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: TColors.textSecondary,
                              // fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Address (swapped with category)
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
                          _buildStatusBadge(isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Action Buttons
            if (_shouldShowActionButtons()) ...[
              const SizedBox(height: 12),
              _buildActionButtons(isDark),
            ],
            // View Bids Button for BIDDING status
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

  Widget _buildTaskImage(bool isDark) {
    final imageUrl = task.media.isNotEmpty ? task.media.first.file : null;
    final categoryColor = CategoryHelper.getCategoryColor(task.category);
    final categoryIcon = CategoryHelper.getCategoryIcon(task.category);

    if (imageUrl != null) {
      // Show task image if available
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Show category icon with color if no image
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDark
              ? categoryColor.withValues(alpha: 0.2)
              : categoryColor.withValues(alpha: 0.1),
        ),
        child: Center(
          child: Icon(
            categoryIcon,
            color: isDark
                ? categoryColor.withValues(alpha: 0.8)
                : categoryColor,
            size: 32,
          ),
        ),
      );
    }
  }

  Widget _buildOptionsMenu(bool isDark) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.grey),
      onSelected: (value) {
        if (value == 'edit' && onEdit != null) {
          onEdit!();
        } else if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    final statusInfo = _getStatusInfo();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? statusInfo['color'].withValues(alpha: 0.2)
            : statusInfo['color'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusInfo['color'].withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statusInfo['icon'] != null) ...[
            Icon(statusInfo['icon'], size: 16, color: statusInfo['textColor']),
            const SizedBox(width: 4),
          ],
          Text(
            statusInfo['label'],
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: statusInfo['textColor'],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo() {
    switch (task.status) {
      case 'POSTED':
      case 'BIDDING':
        final bidLabel = task.bidCount == 0
            ? 'No bids yet'
            : '${task.bidCount} ${task.bidCount == 1 ? 'Bid' : 'Bids'}';
        return {
          'label': bidLabel,
          'icon': task.bidCount > 0 ? Icons.gavel : null,
          'color': TColors.primary,
          'textColor': Colors.black,
        };
      case 'ASSIGNED':
        return {
          'label': 'Assigned',
          'icon': Icons.check_circle,
          'color': Colors.green[100]!,
          'textColor': Colors.green[800]!,
        };
      case 'IN_PROGRESS':
        return {
          'label': 'In progress',
          'icon': Icons.hourglass_top,
          'color': Colors.blue[100]!,
          'textColor': Colors.blue[800]!,
        };

      case 'COMPLETED':
        return {
          'label': 'Delivered',
          'icon': Icons.done_all,
          'color': Colors.orange[100]!,
          'textColor': Colors.orange[800]!,
        };
      case 'CONFIRMED':
        return {
          'label': 'Completed',
          'icon': Icons.verified,
          'color': Colors.grey[200]!,
          'textColor': Colors.grey[800]!,
        };
      case 'DISPUTED':
        return {
          'label': 'Disputed',
          'icon': Icons.warning,
          'color': Colors.red[100]!,
          'textColor': Colors.red[800]!,
        };
      case 'CANCELLED':
        return {
          'label': 'Cancelled',
          'icon': Icons.cancel,
          'color': Colors.grey[300]!,
          'textColor': Colors.grey[700]!,
        };
      default:
        return {
          'label': task.status,
          'icon': null,
          'color': Colors.grey[200]!,
          'textColor': Colors.grey[800]!,
        };
    }
  }

  bool _shouldShowActionButtons() {
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

  Widget _buildActionButtons(bool isDark) {
    switch (task.status) {
      case 'ASSIGNED':
      case 'IN_PROGRESS':
        if (isTasker) {
          return Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  onPressed: onMessagePoster ?? onMessageTasker,
                  text: 'Message poster',
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
        if (isTasker) {
          return PrimaryButton(
            onPressed: onMessagePoster ?? onMessageTasker,
            text: 'Message poster',
            icon: Icons.chat_bubble_outline,
            height: 40,
            fontSize: 13,
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
                onPressed: onMessageTasker ?? () {},
                text: 'Chat',
                icon: Icons.chat_bubble_outline,
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
          icon: Icons.star_rate_rounded, // or star_outline
          height: 40,
          fontSize: 13,
        );
      case 'DISPUTED':
        return PrimaryButton(
          onPressed: onViewDispute,
          text: 'View Dispute',
          icon: Icons.warning_amber_rounded,
          height: 40,
          fontSize: 13,
          backgroundColor: Colors.red[100],
          foregroundColor: Colors.red[900],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
