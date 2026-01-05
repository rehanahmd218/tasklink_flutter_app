import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/features/place_bid_controller.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';

class BidPitchInput extends StatelessWidget {
  final PlaceBidController controller;

  const BidPitchInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Why are you the best fit?', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        AppTextField(
          controller: controller.description,
          maxLines: 5,
          hint: "Hi Alice! I have 5 years of experience cleaning 2-bedroom apartments. I bring my own eco-friendly supplies and I'm available to start immediately...",
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Min 50 characters', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[400])),
          ),
        ),
      ],
    );
  }
}
