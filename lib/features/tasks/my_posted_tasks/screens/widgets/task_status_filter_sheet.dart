import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Filter options for task status (same for Poster and Tasker)
const List<String> taskStatusFilterOptions = [
  'All',
  'Active',
  'Bidding',
  'Assigned',
  'Delivered',
  'Completed',
  'Disputed',
  'Canceled',
];

/// Icons for each filter option
IconData _iconForFilter(String filter) {
  switch (filter) {
    case 'All':
      return Icons.format_list_bulleted;
    case 'Active':
      return Icons.pending_actions;
    case 'Bidding':
      return Icons.gavel;
    case 'Assigned':
      return Icons.person;
    case 'Delivered':
      return Icons.local_shipping_outlined;
    case 'Completed':
      return Icons.check_circle_outline;
    case 'Disputed':
      return Icons.flag_outlined;
    case 'Canceled':
      return Icons.cancel_outlined;
    default:
      return Icons.filter_list;
  }
}

/// Bottom sheet for filtering tasks by status. Apply button fetches with selected filter.
class TaskStatusFilterSheet extends StatefulWidget {
  final String selectedFilter;
  final int taskCount;
  final ValueChanged<String> onApply;

  const TaskStatusFilterSheet({
    super.key,
    required this.selectedFilter,
    required this.taskCount,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required String selectedFilter,
    required int taskCount,
    required ValueChanged<String> onApply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskStatusFilterSheet(
        selectedFilter: selectedFilter,
        taskCount: taskCount,
        onApply: onApply,
      ),
    );
  }

  @override
  State<TaskStatusFilterSheet> createState() => _TaskStatusFilterSheetState();
}

class _TaskStatusFilterSheetState extends State<TaskStatusFilterSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final taskCount = _selected == widget.selectedFilter ? widget.taskCount : null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.backgroundDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Filter by Status',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : TColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: taskStatusFilterOptions.map((option) {
                    final isSelected = option == _selected;
                    return _FilterChip(
                      label: option,
                      icon: _iconForFilter(option),
                      isSelected: isSelected,
                      taskCount: isSelected ? taskCount : null,
                      isDark: isDark,
                      onTap: () => setState(() => _selected = option),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.onApply(_selected);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_forward, size: 20),
                  label: const Text('Apply Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single filter option chip (used in sheet; selection handled by parent state)
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final int? taskCount;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.taskCount,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      child: Material(
        color: isSelected
            ? TColors.primary.withValues(alpha: 0.2)
            : (isDark ? Colors.grey[850] : Colors.grey[200]),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? TColors.primary
                      : (isDark ? Colors.grey[400] : Colors.grey[700]),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white : TColors.textPrimary,
                        ),
                      ),
                      if (taskCount != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '$taskCount tasks',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey[400]
                                : TColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: 20,
                    color: TColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
