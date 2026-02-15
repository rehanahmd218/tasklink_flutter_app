import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SafePaymentWarning extends StatelessWidget {
  const SafePaymentWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue[900]?.withValues(alpha: 0.1) : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.blue[900]!.withValues(alpha: 0.3) : Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user, color: isDark ? Colors.blue[400] : Colors.blue[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safe Payments',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.blue[100] : Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Payment is held securely in escrow until the task is completed to your satisfaction.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? Colors.blue[300] : Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
