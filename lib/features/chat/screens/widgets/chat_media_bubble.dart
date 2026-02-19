import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/models/chat/chat_message_media_model.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'chat_media_thumbnail.dart';

/// Bubble that shows all media in small fixed boxes and optional text below.
class ChatMediaBubble extends StatelessWidget {
  final List<ChatMessageMediaModel> media;
  final String messageText;
  final String time;
  final bool isMe;
  final String? avatarUrl;
  final bool isRead;

  const ChatMediaBubble({
    super.key,
    required this.media,
    required this.messageText,
    required this.time,
    required this.isMe,
    this.avatarUrl,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = messageText.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
                children: media
                    .map((m) => ChatMediaThumbnail(media: m))
                    .toList(),
              ),
              if (hasText) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: isMe
                        ? TColors.primary.withValues(alpha: 0.2)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    messageText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                  if (isMe && isRead) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, size: 14, color: TColors.primary),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
