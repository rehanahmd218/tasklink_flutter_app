import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';

class PaymentBottomBar extends StatelessWidget {
  final bool isDark;
  final String amount;
  final bool isLoading;
  final VoidCallback onPay;
  final VoidCallback onAddFunds;

  const PaymentBottomBar({
    super.key,
    required this.isDark,
    required this.amount,
    this.isLoading = false,
    required this.onPay,
    required this.onAddFunds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: onPay,
              text: 'Pay $amount',
              isLoading: isLoading,
              icon: Icons.arrow_forward,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: onAddFunds,
                child: Text(
                  'Add Funds',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6b6a38),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 14,
                color: isDark
                    ? const Color(0xFF8a8860)
                    : const Color(0xFF6b6a38),
              ),
              const SizedBox(width: 4),
              Text(
                'Funds are held securely in escrow until the task is marked complete.',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF8a8860)
                      : const Color(0xFF6b6a38),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
