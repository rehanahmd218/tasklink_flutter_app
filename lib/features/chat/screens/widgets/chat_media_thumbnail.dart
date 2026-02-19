import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tasklink/models/chat/chat_message_media_model.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/utils/http/api_config.dart';

/// Fixed-size thumbnail for chat media. Tap opens full-screen viewer (images only).
class ChatMediaThumbnail extends StatelessWidget {
  static const double size = 72;

  final ChatMessageMediaModel media;

  const ChatMediaThumbnail({super.key, required this.media});

  String get _resolvedUrl => ApiConfig.mediaFileUrl(media.file);

  void _openFullScreen(BuildContext context) {
    if (!media.isImage) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ),
          body: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: _resolvedUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(color: TColors.primary),
                ),
                errorWidget: (_, __, e) => const Icon(Icons.broken_image, color: Colors.white54, size: 48),
              ),
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullScreen(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
          border: Border.all(color: TColors.primary.withValues(alpha: 0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: media.isImage
            ? CachedNetworkImage(
                imageUrl: _resolvedUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: TColors.primary),
                  ),
                ),
                errorWidget: (_, __, e) => const Icon(Icons.broken_image, size: 28),
              )
            : Center(
                child: Icon(
                  Icons.insert_drive_file,
                  size: 28,
                  color: Colors.grey[600],
                ),
              ),
      ),
    );
  }
}
