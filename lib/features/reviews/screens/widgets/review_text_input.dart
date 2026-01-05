import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';

class ReviewTextInput extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;

  const ReviewTextInput({
    super.key,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'DETAILED REVIEW',
            controller: controller,
            maxLines: 5,
            hint: 'Share your experience with Sarah... Was the task completed as expected?',
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text('0/500', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[400])),
          ),
        ],
      ),
    );
  }
}
