import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisputeCreationTaskCard extends StatelessWidget {
  final String taskTitle;
  final String taskerName;
  final String orderId;
  final String date;
  final String imageUrl;

  const DisputeCreationTaskCard({
    super.key,
    required this.taskTitle,
    required this.taskerName,
    required this.orderId,
    required this.date,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2d2c18) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF44432d) : const Color(0xFFe9e8ce)),
        boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(taskTitle, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d)))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green[900]!.withValues(alpha: 0.3) : Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Completed', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green[800])),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Tasker: $taskerName', style: GoogleFonts.inter(fontSize: 14, color: isDark ? Colors.grey[400] : const Color(0xFF9e9d47))),
                Text('Order ID: #$orderId • $date', style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey[400] : const Color(0xFF9e9d47))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
