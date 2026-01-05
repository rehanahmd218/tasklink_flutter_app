import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';

class PostedTasksTabs extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabSelected;

  const PostedTasksTabs({
    super.key, 
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
       decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[100]!))),
       child: Row(
         children: [
           _buildTab('Active', activeTab == 'Active', isDark),
           const SizedBox(width: 24),
           _buildTab('Completed', activeTab == 'Completed', isDark),
           const SizedBox(width: 24),
           _buildTab('Archived', activeTab == 'Archived', isDark),
         ],
       ),
    );
  }

  Widget _buildTab(String label, bool isActive, bool isDark) {
    return GestureDetector(
      onTap: () => onTabSelected(label),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 2),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? (isDark ? Colors.white : TColors.textPrimary) : TColors.textSecondary,
              ),
            ),
          ),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: isActive ? TColors.primary : Colors.transparent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            ),
          ),
        ],
      ),
    );
  }
}
