import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';

class ChatTaskHeader extends StatelessWidget {
  final String taskName;

  const ChatTaskHeader({super.key, required this.taskName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2d2d1e) : const Color(0xFFf4f4e6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: TColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.build, size: 18, color: Colors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CURRENT TASK', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                  const SizedBox(height: 2),
                  Text(taskName, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
                ],
              ),
            ),
            SecondaryButton(
              onPressed: () {},
              text: 'Details',
              width: 80, // Approximate width
              height: 32, // Small height
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
