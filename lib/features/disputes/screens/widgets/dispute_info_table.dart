import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisputeInfoTable extends StatelessWidget {
  final Map<String, String> data;

  const DisputeInfoTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2c2b14) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dispute Information', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Table(
              columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
              children: data.entries.map((e) => _buildTableRow(e.key, e.value, isDark, isBadge: e.key == 'Reason')).toList(),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value, bool isDark, {bool isBadge = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFa8a760) : const Color(0xFF9e9d47))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: isBadge
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.red[900]!.withValues(alpha: 0.3) : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.red[300] : Colors.red[700])),
                  ),
                )
              : Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
        ),
      ],
    );
  }
}
