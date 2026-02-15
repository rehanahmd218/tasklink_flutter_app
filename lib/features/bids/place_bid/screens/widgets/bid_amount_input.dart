import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/utils/validators/form_validators.dart';

class BidAmountInput extends StatelessWidget {
  final BidController controller;

  const BidAmountInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Offer',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            TextFormField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              validator: FormValidators.validateBidAmount,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey[200]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey[200]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: TColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            Positioned(
              left: 20,
              child: Text(
                'Rs',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Positioned(
              right: 20,
              child: Text(
                'Rs',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // // Fees
        // Row(
        //   children: [
        //     const Icon(Icons.info, size: 16, color: TColors.primary),
        //     const SizedBox(width: 8),
        //     Expanded(
        //       child: Obx(
        //         () => Text(
        //           'TaskLink fee is 10%. You will earn ~\$${controller.earnings.toStringAsFixed(2)} after fees.',
        //           style: GoogleFonts.inter(
        //             fontSize: 12,
        //             color: Colors.grey[500],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
