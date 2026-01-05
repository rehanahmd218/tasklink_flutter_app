import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DescriptionText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final bool expandable;
  const DescriptionText({
    super.key,
    required this.text,
    this.maxLines,
    this.expandable = false,
  });
  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: maxLines,
          overflow: maxLines != null ? TextOverflow.ellipsis : null,
          style: GoogleFonts.inter(
            height: 1.5,
            color: isDark ? Colors.grey[300] : Colors.grey[800],
            fontSize: 14,
          ),
        ),
        if (expandable) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Show more',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
          ),
        ]
      ],
    );
  }
}