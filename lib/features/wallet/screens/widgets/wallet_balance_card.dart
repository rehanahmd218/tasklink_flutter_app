import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class WalletBalanceCard extends StatelessWidget {
  final bool isDark;
  final String totalBalance;
  final String availableBalance;
  final String pendingBalance;

  const WalletBalanceCard({
    super.key,
    required this.isDark,
    required this.totalBalance,
    required this.availableBalance,
    required this.pendingBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : const Color(0xFF1c1c0d),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Balance', style: GoogleFonts.inter(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(totalBalance, style: GoogleFonts.inter(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance_wallet, color: TColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AVAILABLE', style: GoogleFonts.inter(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: TColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(availableBalance, style: GoogleFonts.inter(color: TColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white10),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PENDING', style: GoogleFonts.inter(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.pending, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(pendingBalance, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
