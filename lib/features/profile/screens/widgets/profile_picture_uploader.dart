import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../utils/constants/colors.dart';

class ProfilePictureUploader extends StatelessWidget {
  final bool isDark;
  final String? imageUrl;
  final File? localImage;
  final VoidCallback onTap;

  const ProfilePictureUploader({
    super.key,
    required this.isDark,
    this.imageUrl,
    this.localImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF4a492a)
                          : const Color(0xFFffffff),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipOval(child: _buildImage()),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF23220f)
                            : const Color(0xFFf8f8f5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Text(
              'Change Profile Photo',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: TColors.primary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Priority: local image > network image > placeholder
    if (localImage != null) {
      return Image.file(
        localImage!,
        fit: BoxFit.cover,
        width: 128,
        height: 128,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: 128,
        height: 128,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 128,
      height: 128,
      color: isDark ? const Color(0xFF2d2c1b) : Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 64,
        color: isDark ? Colors.grey[600] : Colors.grey[400],
      ),
    );
  }
}
