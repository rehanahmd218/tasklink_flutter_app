import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';

class TaskPosterProfile extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final double rating;
  final int reviews;
  final VoidCallback? onTap;

  const TaskPosterProfile({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.reviews,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? TColors.darkContainer : TColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? TColors.darkBorderPrimary
                : TColors.borderSecondary.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: TColors.primary, width: 2),
                    color: avatarUrl.isEmpty
                        ? TColors.primary.withValues(alpha: 0.1)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: avatarUrl.isEmpty
                        ? Icon(Icons.person, size: 28, color: TColors.primary)
                        : CachedNetworkImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: TColors.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 28,
                              color: TColors.primary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? TColors.white : TColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: TColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? TColors.white : TColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($reviews reviews)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: TColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: TColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
