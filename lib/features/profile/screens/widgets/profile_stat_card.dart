import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;
  final bool isRating;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.isDark,
    this.isRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2d2c1b) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
        ),
        child: Column(
          children: [
            if (isRating) ...[
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                   const Icon(Icons.star, color: TColors.primary, size: 20),
                 ],
               )
            ] else 
              Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}
