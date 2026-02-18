import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';

/// Task Details Footer - Tasker assigned (Deliver + Cancel)
///
/// Shown when the current user is the assigned tasker and task is ASSIGNED or IN_PROGRESS.
class TaskDetailsTaskerAssignedFooter extends StatelessWidget {
  final VoidCallback onDeliver;
  final VoidCallback onCancel;

  const TaskDetailsTaskerAssignedFooter({
    super.key,
    required this.onDeliver,
    required this.onCancel,
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
      child: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              onPressed: onCancel,
              text: 'Cancel',
              icon: Icons.cancel_outlined,
              height: 48,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              onPressed: onDeliver,
              text: 'Deliver',
              icon: Icons.check_circle_outline,
              height: 48,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
