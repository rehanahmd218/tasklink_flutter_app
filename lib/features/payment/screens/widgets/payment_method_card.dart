import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class PaymentMethodCard extends StatelessWidget {
  final bool isDark;
  final String balance;
  final double progress;
  final String usedAmount;
  final String remainingAmount;

  const PaymentMethodCard({
    super.key,
    required this.isDark,
    required this.balance,
    required this.progress,
    required this.usedAmount,
    required this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PAYMENT METHOD', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF9e9d47))),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: TColors.primary, borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.account_balance_wallet, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TaskLink Wallet', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                          Text('Main Balance', style: GoogleFonts.inter(fontSize: 12, color: isDark ? const Color(0xa3a180ff) : const Color(0xFF6b6a38))),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(balance, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text('Sufficient funds', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: isDark ? const Color(0xFF403e1e) : const Color(0xFFf0f0e8),
                  valueColor: const AlwaysStoppedAnimation<Color>(TColors.primary),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$usedAmount used', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                  Text('$remainingAmount remaining', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: isDark ? const Color(0xa3a180ff) : const Color(0xFF6b6a38))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
