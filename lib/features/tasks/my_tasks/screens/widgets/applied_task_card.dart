import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';

class AppliedTaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String bid;

  const AppliedTaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bid,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RoundedContainer(
      backgroundColor: isDark ? const Color(0xFF27272a) : const Color(0xFFfcfcf8),
      borderColor: isDark ? Colors.grey[800] : Colors.grey[100],
      showBorder: true,
      padding: const EdgeInsets.all(16),
      radius: 12,
      child: Column(
        children: [
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                   const SizedBox(height: 4),
                   Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                 ],
               ),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Text('Your Bid', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                   Text(bid, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                 ],
               ),
             ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[100]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Row(
                 children: [
                   Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                   const SizedBox(width: 8),
                   Text('Waiting for response', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.orange)),
                 ],
               ),
               Text('View Details', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
