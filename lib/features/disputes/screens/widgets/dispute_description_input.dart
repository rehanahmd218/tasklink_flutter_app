import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';

class DisputeDescriptionInput extends StatelessWidget {
  final TextEditingController controller;

  const DisputeDescriptionInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           AppTextField(
             label: 'Additional Details', 
             controller: controller,
             maxLines: 6,
             hint: 'Please describe the issue in detail. Include times, interactions, and specific concerns...',
           ),
           Align(
             alignment: Alignment.centerRight,
             child: Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: Text('0/500 characters', style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey[500] : const Color(0xFF9e9d47))),
             ),
           ),
        ],
      );
  }
}
