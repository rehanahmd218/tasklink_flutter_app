import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TaskEvidenceGallery extends StatelessWidget {
  final List<String> photos;
  final VoidCallback onAddPhoto;

  const TaskEvidenceGallery({
    super.key,
    required this.photos,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task Evidence',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.yellow[400] : Colors.yellow[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: photos.length + 1, // +1 for Add Button
            itemBuilder: (context, index) {
              if (index == photos.length) {
                // Add Photo Button
                return _buildAddPhotoButton(context, isDark);
              }
              // Photo Item
              return _buildPhotoItem(photos[index]);
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Photos help document the work and ensure quality. Both you and the Tasker can upload images.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: TColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: TColors.grey,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                ),
              ),
              child: Text(
                'Before',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: onAddPhoto,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
            width: 2,
            style: BorderStyle.solid, // Dashed not directly supported by Border.all, using solid for now or custom painter
          ),
          color: isDark ? TColors.darkContainer : TColors.backgroundLight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? TColors.backgroundDark : TColors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_a_photo, color: TColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: TColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

