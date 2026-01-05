import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';

class NotificationFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;

  const NotificationFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? TColors.primary : (isDark ? const Color(0xFF2c2b18) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]!)),
        boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 2)] : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.black : (isDark ? Colors.grey[300] : Colors.grey[600]),
        ),
      ),
    );
  }
}
