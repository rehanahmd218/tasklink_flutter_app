import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Empty state wrapped in a scrollable so RefreshIndicator works when the task list is empty.
class TasksEmptyStateWithRefresh extends StatelessWidget {
  final bool isDark;
  final String filterLabel;
  final Future<void> Function() onRefresh;

  const TasksEmptyStateWithRefresh({
    super.key,
    required this.isDark,
    required this.filterLabel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: TColors.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: _buildEmptyContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filterLabel == 'All'
                ? 'No tasks found for your role'
                : 'No tasks in $filterLabel',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
