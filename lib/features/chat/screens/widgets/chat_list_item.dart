import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';

class ChatListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String? avatarUrl;
  final String? initials;
  final bool isOnline;
  final int unreadCount;
  final String contextLabel;
  final IconData contextIcon;
  final bool isRead;
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.avatarUrl,
    this.initials,
    this.isOnline = false,
    this.unreadCount = 0,
    required this.contextLabel,
    required this.contextIcon,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2d2c1b) : Colors.white,
          borderRadius: BorderRadius.circular(16),
           boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
              ),
           ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (avatarUrl != null)
                  CircleAvatar(radius: 28, backgroundImage: CachedNetworkImageProvider(avatarUrl!))
                else
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[100]!),
                    ),
                    alignment: Alignment.center,
                    child: Text(initials ?? '', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                  ),
                if (isOnline)
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? const Color(0xFF2d2c1b) : Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black), maxLines: 1)),
                      Text(time, style: GoogleFonts.inter(fontSize: 12, color: TColors.primary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal, color: isDark ? Colors.grey[300] : Colors.grey[700]), 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: TColors.primary, shape: BoxShape.circle),
                          child: Text('$unreadCount', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                        )
                      else if (isRead)
                         const Icon(Icons.done_all, size: 16, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(contextIcon, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(contextLabel, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
