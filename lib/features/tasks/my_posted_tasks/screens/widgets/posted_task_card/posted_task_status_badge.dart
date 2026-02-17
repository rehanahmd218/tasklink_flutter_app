import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/utils/constants/colors.dart';

class PostedTaskStatusBadge extends StatelessWidget {
  final TaskModel task;
  final bool isDark;

  const PostedTaskStatusBadge({
    super.key,
    required this.task,
    required this.isDark,
  });

  static Map<String, dynamic> getStatusInfo(TaskModel task) {
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

  @override
  Widget build(BuildContext context) {
    final statusInfo = getStatusInfo(task);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? (statusInfo['color'] as Color).withValues(alpha: 0.2)
            : statusInfo['color'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (statusInfo['color'] as Color).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statusInfo['icon'] != null) ...[
            Icon(
              statusInfo['icon'] as IconData,
              size: 16,
              color: statusInfo['textColor'] as Color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            statusInfo['label'] as String,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: statusInfo['textColor'] as Color,
            ),
          ),
        ],
      ),
    );
  }
}
