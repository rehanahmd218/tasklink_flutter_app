import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/features/wallet/screens/widgets/withdraw/payout_method_selection.dart';
import 'package:tasklink/features/wallet/screens/widgets/withdraw/withdraw_amount_input.dart';
import 'package:tasklink/features/wallet/screens/widgets/withdraw/withdraw_balance_card.dart';
import 'package:tasklink/features/wallet/screens/widgets/withdraw/withdraw_percentage_chips.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedPayoutMethod = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: const PrimaryAppBar(title: 'Withdraw Funds'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available Balance
                WithdrawBalanceCard(
                  isDark: isDark,
                  balance: '\$120.50',
                ),
                const SizedBox(height: 32),
                
                // Withdrawal Amount
                WithdrawAmountInput(
                  isDark: isDark,
                  controller: _amountController,
                  maxAmount: '120.50',
                ),
                const SizedBox(height: 12),
                
                // Percentage Chips
                WithdrawPercentageChips(
                  isDark: isDark,
                  onPercentageSelected: (percentage) {
                    // Logic to calculate percentage
                    _amountController.text = (120.50 * percentage).toStringAsFixed(2);
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Payout Method
                PayoutMethodSelection(
                  isDark: isDark,
                  selectedPayoutMethod: _selectedPayoutMethod,
                  onPayoutMethodChanged: (index) {
                    setState(() {
                      _selectedPayoutMethod = index;
                    });
                  },
                  onManage: () {},
                ),
              ],
            ),
          ),
          
          // Sticky Bottom Bar
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
                border: Border(top: BorderSide(color: isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce))),
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    onPressed: () {},
                    text: 'Request Withdrawal',
                    icon: Icons.arrow_forward,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user, size: 14, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f)),
                      const SizedBox(width: 4),
                      Text('Secure Encrypted Transfer', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f).withValues(alpha: 0.8))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
