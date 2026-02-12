import 'package:flutter/material.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/features/task_details/widgets/task_detail_card.dart';
import 'package:intl/intl.dart';

/// Task Meta Information Grid
///
/// Shows date/time and category in a grid layout
class TaskMetaGrid extends StatelessWidget {
  final TaskModel task;

  const TaskMetaGrid({super.key, required this.task});

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (taskDate == today) {
      dateStr = 'Today';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      dateStr = 'Tomorrow';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      dateStr = 'Yesterday';
    } else {
      dateStr = DateFormat('MMM d, yyyy').format(dateTime);
    }

    final timeStr = DateFormat('h:mm a').format(dateTime);
    return '$dateStr, $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TaskDetailCard(
              icon: Icons.calendar_today,
              label: 'Date & Time',
              value: _formatDateTime(task.createdAt),
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TaskDetailCard(
              icon: Icons.category,
              label: 'Category',
              value: task.category,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
