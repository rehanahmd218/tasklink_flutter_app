import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/controllers/features/place_bid_controller.dart';

class BidSummaryFooter extends StatelessWidget {
  final PlaceBidController controller;

  const BidSummaryFooter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? TColors.backgroundDark.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Bid Amount', style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.grey)),
              Obx(() => Text(
                '\$${controller.rxBidAmount.value.toStringAsFixed(2)}',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
              )),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            onPressed: () {},
            text: 'Submit Bid',
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}
