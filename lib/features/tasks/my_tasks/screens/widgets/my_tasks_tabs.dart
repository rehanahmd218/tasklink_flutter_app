import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class MyTasksTabs extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabSelected;

  const MyTasksTabs({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabItem('In Progress', activeTab == 'In Progress', isDark),
          _buildTabItem('Applied (3)', activeTab == 'Applied (3)', isDark),
          _buildTabItem('History', activeTab == 'History', isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, bool isActive, bool isDark) {
    return GestureDetector(
      onTap: () => onTabSelected(label),
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? TColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? (isDark ? Colors.white : Colors.black)
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
