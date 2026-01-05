import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/post_task_controller.dart';

class PostTaskDateBudgetRow extends StatelessWidget {
  final PostTaskController controller;

  const PostTaskDateBudgetRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text('Details', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
         const SizedBox(height: 12),
         Row(
           children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text('Due Date', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                     const SizedBox(height: 8),
                     Container(
                       height: 52,
                       padding: const EdgeInsets.symmetric(horizontal: 12),
                       decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF27272A) : Colors.white,
                          border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(12),
                       ),
                       child: Row(
                         children: [
                           Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                           const SizedBox(width: 8),
                           const Text('Sat, Nov 12'),
                           const Spacer(),
                           Icon(Icons.expand_more, color: Colors.grey[600]),
                         ],
                       ),
                     ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text('Budget', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                     const SizedBox(height: 8),
                     Stack(
                       children: [
                         TextField(
                           controller: controller.budget,
                           keyboardType: TextInputType.number,
                           style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
                           decoration: InputDecoration(
                             prefixText: '\$ ',
                             prefixStyle: GoogleFonts.inter(color: Colors.grey[600], fontWeight: FontWeight.w600),
                             filled: true,
                             fillColor: isDark ? const Color(0xFF27272A) : Colors.white,
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[200]!)),
                             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[200]!)),
                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: TColors.primary)),
                             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                           ),
                         ),
                       ],
                     ),
                  ],
                ),
              ),
           ],
         ),
      ],
    );
  }
}
