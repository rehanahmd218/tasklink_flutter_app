import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/utils/formatters/date_formatter.dart';

/// Task Details Footer - Place Bid
///
/// Footer for taskers to place a bid
class TaskDetailsPlaceBidFooter extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onPlaceBid;

  const TaskDetailsPlaceBidFooter({
    super.key,
    required this.task,
    required this.onPlaceBid,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? TColors.backgroundDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                formatCurrency(task.budget),
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            onPressed: onPlaceBid,
            text: 'Place a Bid',
            icon: Icons.gavel,
          ),
        ],
      ),
    );
  }
}
