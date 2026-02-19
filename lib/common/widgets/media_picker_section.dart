import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

/// Reusable section for picking up to [maxFiles] images (e.g. post task, dispute).
/// Parent holds the list and implements [onAddRequest] (e.g. with [ImagePicker.pickMultiImage]).
class MediaPickerSection extends StatelessWidget {
  final List<XFile> images;
  final int maxFiles;
  final VoidCallback onAddRequest;
  final void Function(int index) onRemove;
  final String? title;
  final String? subtitle;

  const MediaPickerSection({
    super.key,
    required this.images,
    required this.maxFiles,
    required this.onAddRequest,
    required this.onRemove,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images.length < maxFiles)
              GestureDetector(
                onTap: onAddRequest,
                child: Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF27272A)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ...images.asMap().entries.map((entry) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(entry.value.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onRemove(entry.key),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        if (images.isEmpty && (title != null || subtitle != null))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'No photos added yet.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
      ],
    );
  }
}
