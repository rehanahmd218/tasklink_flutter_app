import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class WalletTransactionItem extends StatelessWidget {
  final String title;
  final String time;
  final String amount;
  final String status;
  final IconData icon;
  final Color iconColor;
  final bool isDark;
  final Color? textClass;

  const WalletTransactionItem({
    super.key,
    required this.title,
    required this.time,
    required this.amount,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.isDark,
    this.textClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!))),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.1) : (iconColor == TColors.primary ? TColors.primary.withValues(alpha: 0.2) : Colors.grey[100]), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: isDark ? (iconColor == TColors.primary ? TColors.primary : Colors.grey[300]) : (iconColor == TColors.primary ? Colors.black : Colors.grey[600])),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                Text(time, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: textClass ?? (isDark ? Colors.white : Colors.black))),
              Text(status, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
}
