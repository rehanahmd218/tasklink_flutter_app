import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';

class HomeFilterBar extends StatelessWidget {
  const HomeFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', Icons.apps, isActive: true, isDark: isDark),
          _buildFilterChip('Moving', Icons.widgets_outlined, isDark: isDark), // box icon substitute
          _buildFilterChip('Cleaning', Icons.cleaning_services_outlined, isDark: isDark),
          _buildFilterChip('Gardening', Icons.yard_outlined, isDark: isDark), // potted_plant substitute
          _buildFilterChip('Assembly', Icons.build_outlined, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, {bool isActive = false, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Chip(
        label: Text(label),
        avatar: Icon(icon, size: 18, color: isActive ? Colors.black : (isDark ? Colors.grey[300] : Colors.grey[700])),
        backgroundColor: isActive ? TColors.primary : (isDark ? Colors.grey[800] : Colors.white),
        labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight:  FontWeight.w600, color: isActive ? Colors.black : (isDark ? Colors.grey[300] : Colors.grey[700])),
        side: isActive ? BorderSide.none : BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    );
  }
}
