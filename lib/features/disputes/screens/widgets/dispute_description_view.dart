import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisputeDescriptionView extends StatelessWidget {
  final String description;

  const DisputeDescriptionView({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2c2b14) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Description', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFf8f8f5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              description,
              style: GoogleFonts.inter(fontSize: 16, color: isDark ? Colors.grey[300] : const Color(0xFF1c1c0d), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
