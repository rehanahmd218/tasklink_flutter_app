import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentBreakdown extends StatelessWidget {
  final bool isDark;
  final String taskPrice;
  final String serviceFee;
  final String total;

  const PaymentBreakdown({
    super.key,
    required this.isDark,
    required this.taskPrice,
    required this.serviceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PAYMENT BREAKDOWN', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF9e9d47))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2c2b14) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? const Color(0xFF403e1e) : const Color(0xFFe9e8ce)),
            boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
          ),
          child: Column(
            children: [
              _buildBreakdownRow('Task Price', taskPrice, isDark),
              Divider(height: 1, thickness: 1, color: isDark ? const Color(0xFF403e1e) : const Color(0xFFf0f0e8)),
              _buildBreakdownRow('Service Fee (5%)', serviceFee, isDark),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total to Pay', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                    Text(total, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 14, color: isDark ? const Color(0xa3a180ff) : const Color(0xFF6b6a38))),
          Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
        ],
      ),
    );
  }
}
