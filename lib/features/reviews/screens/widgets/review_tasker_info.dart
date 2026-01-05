import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../utils/constants/colors.dart';

class ReviewTaskerInfo extends StatelessWidget {
  final bool isDark;
  final String imageUrl;
  final String taskerName;
  final String taskTitle;

  const ReviewTaskerInfo({
    super.key,
    required this.isDark,
    required this.imageUrl,
    required this.taskerName, // Not used in design explicitly but passed for flexibility if needed relative to text
    required this.taskTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? const Color(0xFF4a492a) : Colors.white, width: 4),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF23220f) : Colors.white),
                ),
                child: Text(
                  'TASKER',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('How was your work with $taskerName?', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Task: $taskTitle', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[400] : Colors.grey[500])),
        ),
      ],
    );
  }
}
