import 'package:flutter/material.dart';


import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/common/widgets/secondary_button.dart';

class WalletActionButtons extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTopUp;
  final VoidCallback onWithdraw;

  const WalletActionButtons({
    super.key,
    required this.isDark,
    required this.onTopUp,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              onPressed: onTopUp,
              text: 'Top Up',
              icon: Icons.add,
              borderRadius: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SecondaryButton(
              onPressed: onWithdraw,
              text: 'Withdraw',
              icon: Icons.arrow_outward,
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }
}
