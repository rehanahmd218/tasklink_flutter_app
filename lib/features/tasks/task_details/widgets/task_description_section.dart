import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';
import 'package:tasklink/common/widgets/description_text.dart';

/// Task Description Widget
///
/// Shows the task description in an expandable container
class TaskDescriptionSection extends StatelessWidget {
  final TaskModel task;

  const TaskDescriptionSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: TColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RoundedContainer(
            padding: const EdgeInsets.all(16),
            backgroundColor: isDark ? const Color(0xFF27272A) : Colors.grey[50],
            child: DescriptionText(text: task.description, expandable: true),
          ),
        ],
      ),
    );
  }
}
