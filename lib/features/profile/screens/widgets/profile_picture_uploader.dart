import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../utils/constants/colors.dart';

class ProfilePictureUploader extends StatelessWidget {
  final bool isDark;
  final String imageUrl;
  final VoidCallback onTap;

  const ProfilePictureUploader({
    super.key,
    required this.isDark,
    required this.imageUrl,
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
                  width: 128, height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? const Color(0xFF4a492a) : const Color(0xFFffffff), width: 4),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                ),
                Positioned(
                  bottom: 0, right: 4,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5), width: 3),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                    ),
                    child: const Icon(Icons.photo_camera, size: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Change Profile Photo',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: TColors.primary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
