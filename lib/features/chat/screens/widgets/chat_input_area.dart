import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/constants/colors.dart';

class ChatInputArea extends StatefulWidget {
  final void Function(String text) onSend;
  final Future<void> Function(File file, {String mediaType})? onAttach;
  final bool isSending;
  /// Pending media IDs (uploaded, not yet sent). Shown in input box with option to remove.
  final List<String> pendingMediaIds;
  /// True while a file is uploading as pending media. Shows a loader in the input box.
  final bool isUploadingMedia;
  final void Function(String id)? onRemovePending;

  const ChatInputArea({
    super.key,
    required this.onSend,
    this.onAttach,
    this.isSending = false,
    this.pendingMediaIds = const [],
    this.isUploadingMedia = false,
    this.onRemovePending,
  });

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty && widget.pendingMediaIds.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x == null || widget.onAttach == null) return;
    final file = File(x.path);
    await widget.onAttach!(file, mediaType: 'IMAGE');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const double _pendingBoxSize = 44;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Use one background for whole input area so there is no color difference on the sides
    final inputBg = isDark ? const Color(0xFF2d2d1e) : const Color(0xFFf4f4e6);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inputBg,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.pendingMediaIds.isNotEmpty || widget.isUploadingMedia) ...[
            SizedBox(
              height: _pendingBoxSize,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.pendingMediaIds.map((id) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: _pendingBoxSize,
                          height: _pendingBoxSize,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white12 : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: TColors.primary.withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Icon(Icons.image_outlined, size: 22),
                        ),
                        if (widget.onRemovePending != null)
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => widget.onRemovePending!(id),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
                  if (widget.isUploadingMedia)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: _pendingBoxSize,
                        height: _pendingBoxSize,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white12 : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: TColors.primary.withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              if (widget.onAttach != null)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: widget.isSending || widget.isUploadingMedia ? null : _pickImage,
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey),
                    border: InputBorder.none,
                    
                  ),
                  style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: TColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: widget.isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_upward, color: Colors.black),
                  onPressed: widget.isSending ? null : _send,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
