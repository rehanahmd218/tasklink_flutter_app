import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class DisputeStatusBanner extends StatelessWidget {
  final String status;
  final String description;

  const DisputeStatusBanner({
    super.key,
    required this.status,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.primary.withValues(alpha: isDark ? 0.1 : 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(color: TColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.hourglass_top, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(fontSize: 14, color: isDark ? const Color(0xFFdcdca8) : const Color(0xFF4b4b24)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
