import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';
import 'package:tasklink/common/widgets/circular_icon.dart';

/// Task Status Banner Widget
///
/// Shows status-specific banner for task owners
class TaskStatusBanner extends StatelessWidget {
  final TaskModel task;

  const TaskStatusBanner({super.key, required this.task});

  Map<String, dynamic> _getStatusInfo() {
    switch (task.status) {
      case 'BIDDING':
        return {
          'title': 'Bidding Open',
          'subtitle': 'Review your applicants below',
          'icon': Icons.gavel,
          'backgroundColor': TColors.primary,
          'borderColor': Colors.yellow.shade400.withValues(alpha: 0.2),
          'iconColor': Colors.black,
          'textColor': Colors.black,
        };
      case 'ASSIGNED':
        return {
          'title': 'Task Assigned',
          'subtitle': 'Waiting for tasker to start',
          'icon': Icons.check_circle,
          'backgroundColor': Colors.green.shade100,
          'borderColor': Colors.green.shade400.withValues(alpha: 0.3),
          'iconColor': Colors.green.shade800,
          'textColor': Colors.green.shade900,
        };
      case 'IN_PROGRESS':
        return {
          'title': 'In Progress',
          'subtitle': 'Task is being worked on',
          'icon': Icons.hourglass_bottom,
          'backgroundColor': Colors.blue.shade100,
          'borderColor': Colors.blue.shade400.withValues(alpha: 0.3),
          'iconColor': Colors.blue.shade800,
          'textColor': Colors.blue.shade900,
        };
      case 'COMPLETED':
        return {
          'title': 'Delivered',
          'subtitle': 'Please review and confirm',
          'icon': Icons.done_all,
          'backgroundColor': Colors.orange.shade100,
          'borderColor': Colors.orange.shade400.withValues(alpha: 0.3),
          'iconColor': Colors.orange.shade800,
          'textColor': Colors.orange.shade900,
        };
      case 'CONFIRMED':
        return {
          'title': 'Completed',
          'subtitle': 'Task successfully completed',
          'icon': Icons.verified,
          'backgroundColor': Colors.grey.shade200,
          'borderColor': Colors.grey.shade400.withValues(alpha: 0.3),
          'iconColor': Colors.grey.shade800,
          'textColor': Colors.grey.shade900,
        };
      default:
        return {
          'title': task.status,
          'subtitle': '',
          'icon': Icons.info,
          'backgroundColor': TColors.primary,
          'borderColor': Colors.yellow.shade400.withValues(alpha: 0.2),
          'iconColor': Colors.black,
          'textColor': Colors.black,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();

    return RoundedContainer(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      backgroundColor: statusInfo['backgroundColor'],
      showBorder: true,
      borderColor: statusInfo['borderColor'],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                statusInfo['icon'],
                color: statusInfo['iconColor'],
                size: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusInfo['title'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusInfo['textColor'],
                    ),
                  ),
                  if (statusInfo['subtitle'].isNotEmpty)
                    Text(
                      statusInfo['subtitle'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: statusInfo['textColor'].withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
            ],
          ),
          CircularIcon(
            icon: Icons.notifications_active,
            backgroundColor: statusInfo['iconColor'].withValues(alpha: 0.2),
            color: statusInfo['iconColor'],
            size: 32,
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}
