import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';

class PostedTaskCard extends StatelessWidget {
  final String title;
  final String posted;
  final String location;
  final String price;
  final String statusLabel;
  final IconData? statusIcon;
  final Color statusColor;
  final Color statusTextColor;
  final String imageUrl;
  final bool isNew;
  final bool hasActions;
  final bool isGrayscale;
  final double opacity;

  const PostedTaskCard({
    super.key,
    required this.title,
    required this.posted,
    required this.location,
    required this.price,
    required this.statusLabel,
    this.statusIcon,
    required this.statusColor,
    required this.statusTextColor,
    required this.imageUrl,
    this.isNew = false,
    this.hasActions = false,
    this.isGrayscale = false,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2c2c1a) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
          boxShadow: [
             BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                       width: 64, height: 64,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8),
                         image: DecorationImage(
                            image: CachedNetworkImageProvider(imageUrl), 
                            fit: BoxFit.cover, 
                            colorFilter: isGrayscale ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null
                         ),
                       ),
                    ),
                    if (isNew)
                      Positioned(
                        top: -8, right: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white, width: 2)),
                          child: Text('NEW', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? Colors.white : TColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          const Icon(Icons.more_horiz, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('$posted • $location', style: GoogleFonts.inter(fontSize: 12, color: TColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(price, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[200] : TColors.textPrimary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? statusColor.withValues(alpha: 0.2) : statusColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                if (statusIcon != null) ...[Icon(statusIcon, size: 16, color: statusTextColor), const SizedBox(width: 4)],
                                Text(statusLabel, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: statusTextColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasActions)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Expanded(child: _buildActionButton('Message Tasker', isDark)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildActionButton('Track Status', isDark)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50], 
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[300] : Colors.grey[700])),
      ),
    );
  }
}
