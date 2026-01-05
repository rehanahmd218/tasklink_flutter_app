import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';

class ChatImageBubble extends StatelessWidget {
  final String imageUrl;
  final String time;
  final bool isMe;
  final bool isRead;

  const ChatImageBubble({
    super.key,
    required this.imageUrl,
    required this.time,
    required this.isMe,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                width: 200, height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: const Radius.circular(16), topRight: const Radius.circular(16), bottomLeft: isMe ? const Radius.circular(16) : Radius.zero, bottomRight: isMe ? Radius.zero : const Radius.circular(16)),
                  image: DecorationImage(image: CachedNetworkImageProvider(imageUrl), fit: BoxFit.cover),
                  border: Border.all(color: TColors.primary, width: 2), // Simulate bubble border
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
        ],
      ),
    );
  }
}
