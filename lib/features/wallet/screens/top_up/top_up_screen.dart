import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/features/wallet/screens/widgets/top_up/payment_method_selection.dart';
import 'package:tasklink/features/wallet/screens/widgets/top_up/top_up_amount_input.dart';
import 'package:tasklink/features/wallet/screens/widgets/top_up/top_up_balance_card.dart';
import 'package:tasklink/features/wallet/screens/widgets/top_up/top_up_quick_add_chips.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedPaymentMethod = 0; // 0 for Card, 1 for Apple Pay

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: const PrimaryAppBar(title: 'Add Funds'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Balance
                TopUpBalanceCard(
                  isDark: isDark,
                  balance: '\$120.50',
                ),
                const SizedBox(height: 32),
                
                // Amount Input
                TopUpAmountInput(
                  isDark: isDark,
                  controller: _amountController,
                ),
                const SizedBox(height: 12),
                
                // Quick Add Chips
                TopUpQuickAddChips(
                  isDark: isDark,
                  onAmountSelected: (value) {
                    _amountController.text = value;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Payment Method
                PaymentMethodSelection(
                  isDark: isDark,
                  selectedPaymentMethod: _selectedPaymentMethod,
                  onPaymentMethodChanged: (index) {
                    setState(() {
                      _selectedPaymentMethod = index;
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
                    text: 'Confirm Payment',
                    icon: Icons.arrow_forward,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 14, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f)),
                      const SizedBox(width: 4),
                      Text('100% Secure Transaction', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f))),
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
