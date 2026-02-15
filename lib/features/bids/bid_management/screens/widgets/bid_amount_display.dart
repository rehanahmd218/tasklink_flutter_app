import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BidAmountDisplay extends StatelessWidget {
  final String amount;
  final String date;

  const BidAmountDisplay({
    super.key,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Text(amount, style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        Text('Submitted on $date', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
      ],
    );
  }
}
