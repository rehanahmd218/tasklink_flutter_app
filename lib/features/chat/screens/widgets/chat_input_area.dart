import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';

class ChatInputArea extends StatelessWidget {
  const ChatInputArea({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23220f) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFf4f4e6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(color: TColors.primary, shape: BoxShape.circle),
            child: IconButton(icon: const Icon(Icons.arrow_upward, color: Colors.black), onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
