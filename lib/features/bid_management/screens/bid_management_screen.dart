import 'package:flutter/material.dart';
import 'package:tasklink/features/bid_management/screens/widgets/bid_action_buttons.dart';
import 'package:tasklink/features/bid_management/screens/widgets/bid_amount_display.dart';
import 'package:tasklink/features/bid_management/screens/widgets/bid_pitch_display.dart';
import 'package:tasklink/features/bid_management/screens/widgets/bid_status_chip.dart';
import 'package:tasklink/features/bid_management/screens/widgets/bid_task_preview.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';

class BidManagementScreen extends StatelessWidget {
  const BidManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(title: 'Manage Bids'),
      body: Column(
        children: [
          // AppBar
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Task Link
                  BidTaskPreview(
                    title: 'Lawn Mowing & Garden Cleanup',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAr3fJTn31zIPtg9-Tv0QHdbWvknBuARuDIjSA5t5EFgvHq1sUl7D8hfxJjYCwJTGl7DjKXozw1HsXxn1mae5APm3GUtjCmpMDGmOZnFpXlwzEV1gJA7ANhfm4fzxhNq2_cMPrwAWTcg1JH9q1GuNFaSU-OnMMohDyi89ZyiHLMnntVoYptWi7BP2WA__zWMaDvOTbhAJfhUzt_93rSAByT0MWzbfVldfspKBW7MgUbRqogGeYMor8Em4fdWCnWyWgE35LarultZGkR',
                    onTap: () {},
                  ),

                  const SizedBox(height: 32),

                  // Status Chip
                  BidStatusChip(
                    label: 'ACTIVE BID',
                    backgroundColor: isDark
                        ? const Color(0xFF3D421B)
                        : const Color(0xFFEEFCC2),
                    borderColor: isDark
                        ? const Color(0xFF5A6128)
                        : const Color(0xFFD6F089),
                    textColor: isDark
                        ? const Color(0xFFD6F089)
                        : const Color(0xFF3B5204),
                    indicatorColor: Colors.green,
                  ),

                  const SizedBox(height: 16),

                  const BidAmountDisplay(
                    amount: '\$85.00',
                    date: 'Oct 24, 10:30 AM',
                  ),

                  const SizedBox(height: 32),

                  // Pitch
                  const BidPitchDisplay(
                    pitch:
                        "Hi! I have my own professional lawn mowing equipment and leaf blowers. I can complete this task by Saturday afternoon. I have 5 years of experience in garden maintenance and I'll make sure to bag all the clippings for disposal. Looking forward to helping you out!",
                  ),

                  const SizedBox(height: 32),

                  // Actions
                  BidActionButtons(
                    onEdit: () {},
                    onContact: () {},
                    onWithdraw: () {},
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
