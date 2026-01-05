import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BidStatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color indicatorColor;

  const BidStatusChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           Container(width: 8, height: 8, decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: indicatorColor.withValues(alpha: 0.5), blurRadius: 4, spreadRadius: 2)])),
           const SizedBox(width: 8),
           Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
