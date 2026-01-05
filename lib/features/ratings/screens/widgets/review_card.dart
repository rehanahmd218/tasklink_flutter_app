import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/app_card.dart';
import 'package:tasklink/controllers/features/ratings_controller.dart' show ReviewModel;

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AvatarWidget(
                    imageUrl: review.avatarUrl,
                    initials: review.name.substring(0, 1),
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? TColors.white : TColors.textPrimary,
                        ),
                      ),
                      Text(
                        review.date,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: TColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? TColors.darkContainer : TColors.softGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: TColors.primary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? TColors.white : TColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: isDark ? TColors.white : TColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? TColors.darkContainer : TColors.softGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                     Icon(_getIconData(review.taskIcon), size: 14, color: TColors.textSecondary),
                     const SizedBox(width: 6),
                     Text(
                       'Task: ${review.taskName}',
                       style: GoogleFonts.inter(
                         fontSize: 12,
                         fontWeight: FontWeight.w500,
                         color: TColors.textSecondary,
                       ),
                     ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 18, color: TColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      review.likes.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: TColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'plumbing': return Icons.plumbing;
      case 'chair': return Icons.chair; // Requires flutter vector usage or mapping, chair might not exist in default Icons? Icons.chair exists
      case 'grass': return Icons.grass;
      case 'box': return Icons.inventory_2; // 'box' mapping
      default: return Icons.work;
    }
  }
}
