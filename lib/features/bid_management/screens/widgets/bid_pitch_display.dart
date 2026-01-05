import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BidPitchDisplay extends StatelessWidget {
  final String pitch;

  const BidPitchDisplay({super.key, required this.pitch});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: Text('Your Pitch', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black))),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF27272A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
          ),
          child: Text(
            pitch,
            style: GoogleFonts.inter(height: 1.5, color: isDark ? Colors.grey[300] : Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
