import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/utils/formatters/date_formatter.dart';

/// Task Details Header Widget
///
/// Shows task title, budget, and posted time
class TaskDetailsHeader extends StatelessWidget {
  final TaskModel task;
  final bool isOwner;

  const TaskDetailsHeader({
    super.key,
    required this.task,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted time ago at the top
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Posted ${formatTimeAgo(task.createdAt)}',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Task Title
          Text(
            task.title,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : TColors.textPrimary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Budget styled like the image
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              formatCurrency(task.budget),
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
