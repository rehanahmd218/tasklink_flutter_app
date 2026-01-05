import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpBalanceCard extends StatelessWidget {
  final bool isDark;
  final String balance;

  const TopUpBalanceCard({
    super.key,
    required this.isDark,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2d2c15) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce)),
        boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text('Current Balance', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f))),
          const SizedBox(height: 4),
          Text(balance, style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
        ],
      ),
    );
  }
}
