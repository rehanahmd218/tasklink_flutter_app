import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatTypingIndicator extends StatelessWidget {
  final String avatarUrl;

  const ChatTypingIndicator({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
           CircleAvatar(radius: 16, backgroundImage: CachedNetworkImageProvider(avatarUrl)),
           const SizedBox(width: 8),
           Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(color: isDark ? const Color(0xFF2d2d1e) : const Color(0xFFf4f4e6), borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomRight: Radius.circular(16))),
             child: Row(
               children: [
                 _buildDot(0),
                 _buildDot(100),
                 _buildDot(200),
               ],
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildDot(int delay) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6, height: 6,
      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
    );
  }
}
