import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : Colors.grey[500], letterSpacing: 0.5),
      ),
    );
  }
}
