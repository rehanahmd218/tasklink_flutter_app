import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/constants/colors.dart';

class ChatInputArea extends StatefulWidget {
  final void Function(String text) onSend;
  final Future<void> Function(File file, {String mediaType})? onAttach;
  final bool isSending;

  const ChatInputArea({
    super.key,
    required this.onSend,
    this.onAttach,
    this.isSending = false,
  });

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23220f) : Colors.white,
        border: Border(
            top: BorderSide(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          if (widget.onAttach != null)
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: widget.isSending ? null : _pickImage,
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFf4f4e6),
                borderRadius: BorderRadius.circular(20),
              ),
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
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
                color: TColors.primary, shape: BoxShape.circle),
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
    );
  }
}
