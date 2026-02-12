import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';

class PostedTasksTabs extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabSelected;
  final Map<String, int>? taskCounts;

  const PostedTasksTabs({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
    this.taskCounts,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tabs = [
      'All',
      'Bidding',
      'Assigned',

      'Delivered',
      'Completed',
      'Disputed',
      'Cancelled',
    ];

    return Container(
      height: 48, // Fixed height for horizontal list
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
          ),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final count = taskCounts?[tab] ?? 0;
          return _buildTab(tab, activeTab == tab, count, isDark);
        },
      ),
    );
  }

  Widget _buildTab(String label, bool isActive, int count, bool isDark) {
    return GestureDetector(
      onTap: () => onTabSelected(label),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? (isDark ? Colors.white : TColors.textPrimary)
                        : TColors.textSecondary,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '($count)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: isActive
                          ? (isDark ? Colors.white : TColors.textPrimary)
                          : TColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: isActive ? TColors.primary : Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
