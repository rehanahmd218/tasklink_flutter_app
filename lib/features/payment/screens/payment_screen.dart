import 'package:flutter/material.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_bottom_bar.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_breakdown.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_method_card.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_task_card.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: const PrimaryAppBar(title: 'Secure Payment'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Task Card
                const PaymentTaskCard(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuALT-KKiLnes24ZblxdwTW3lYFqalpKa14icsGFTwvq-OI2VcU9vNmTcUlKCj4T3iNteD55gJUBFtVczaubT4r2BtbFI3vhV2M06c69UZpK2V5ePVbdqyk8e3BFT1Yqo8FQg5Gr2_u2M4HkggLjetnKWkkXlClC7oh_fgN7_Z-MDURsrsWQmWdRfxJ9KGEumPUTODR_qW_GyLBrb8QVRTwgGE0XXVL-zAPH7pRhX6Ou6KWvuJWcxXwl6mVt3dqkaDSFxqF8GOoK1qUC',
                  title: 'Assemble IKEA Wardrobe',
                  postId: 'TL-8492',
                ),
                
                const SizedBox(height: 24),
                
                // Payment Breakdown
                PaymentBreakdown(
                  isDark: isDark,
                  taskPrice: '\$50.00',
                  serviceFee: '\$2.50',
                  total: '\$52.50',
                ),
                
                const SizedBox(height: 24),
                
                // Payment Method
                PaymentMethodCard(
                  isDark: isDark,
                  balance: '\$120.00',
                  progress: 0.43,
                  usedAmount: '\$52.50',
                  remainingAmount: '\$67.50',
                ),
              ],
            ),
          ),
          
          // Sticky Footer
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: PaymentBottomBar(
              isDark: isDark,
              amount: '\$52.50',
              onPay: () {},
              onAddFunds: () {},
            ),
          ),
        ],
      ),
    );
  }

}
