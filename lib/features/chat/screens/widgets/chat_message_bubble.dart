import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final String? avatarUrl;
  final bool isRead;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    this.avatarUrl,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && avatarUrl != null) ...[
            CircleAvatar(radius: 16, backgroundImage: CachedNetworkImageProvider(avatarUrl!)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? TColors.primary : (isDark ? const Color(0xFF2d2d1e) : const Color(0xFFf4f4e6)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    message,
                    style: GoogleFonts.inter(fontSize: 15, color: isMe ? const Color(0xFF1c1c0d) : (isDark ? Colors.white : Colors.black87), height: 1.4),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(time, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                    if (isMe && isRead) ...[const SizedBox(width: 4), const Icon(Icons.done_all, size: 14, color: TColors.primary)],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
