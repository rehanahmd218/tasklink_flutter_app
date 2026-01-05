import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/features/wallet/screens/top_up/top_up_screen.dart';
import 'package:tasklink/features/wallet/screens/withdraw/withdraw_screen.dart';
import 'package:tasklink/features/wallet/screens/widgets/wallet_action_buttons.dart';
import 'package:tasklink/features/wallet/screens/widgets/wallet_balance_card.dart';
import 'package:tasklink/features/wallet/screens/widgets/wallet_transaction_item.dart';
import '../../../../utils/constants/colors.dart';


class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Wallet',
        showBackButton: false, // It's a tab screen usually, or main screen
        actions: [
          IconButton(icon: Icon(Icons.tune, color: isDark ? Colors.white : Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            // Balance Card
            WalletBalanceCard(
              isDark: isDark,
              totalBalance: '\$350.00',
              availableBalance: '\$350.00',
              pendingBalance: '\$0.00',
            ),
            
            // Actions
            WalletActionButtons(
              isDark: isDark,
              onTopUp: () => Get.to(() => const TopUpScreen()),
              onWithdraw: () => Get.to(() => const WithdrawScreen()),
            ),
            
            const SizedBox(height: 24),
            
            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Transactions', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                  TextButton(onPressed: () {}, child: Text('See All', style: GoogleFonts.inter(color: Colors.grey[500]))),
                ],
              ),
            ),
            
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                WalletTransactionItem(title: 'Payment: Task #2901', time: 'Today, 10:23 AM', amount: '+\$45.00', status: 'Received', icon: Icons.work, iconColor: TColors.primary, isDark: isDark, textClass: Colors.green),
                WalletTransactionItem(title: 'Withdrawal to Bank', time: 'Yesterday, 4:15 PM', amount: '-\$100.00', status: 'Sent', icon: Icons.account_balance, iconColor: Colors.grey, isDark: isDark),
                WalletTransactionItem(title: 'Top Up', time: 'Oct 24, 09:30 AM', amount: '+\$20.00', status: 'Deposited', icon: Icons.add_card, iconColor: TColors.primary, isDark: isDark, textClass: Colors.green),
                WalletTransactionItem(title: 'Tools Purchase', time: 'Oct 22, 11:00 AM', amount: '-\$54.20', status: 'Payment', icon: Icons.shopping_bag, iconColor: Colors.grey, isDark: isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
