import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final List<double> distribution; // [5 stars %, 4 stars %, ...]

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                averageRating.toString(),
                style: GoogleFonts.inter(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  color: isDark ? TColors.white : TColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (index) {
                  if (index < averageRating.floor()) {
                    return const Icon(Icons.star, color: TColors.primary, size: 20);
                  } else if (index < averageRating) {
                    return const Icon(Icons.star_half, color: TColors.primary, size: 20);
                  } else {
                    return const Icon(Icons.star_border, color: TColors.primary, size: 20);
                  }
                }),
              ),
              const SizedBox(height: 4),
              Text(
                'Based on $totalReviews reviews',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: TColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Distribution Bars
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final starCount = 5 - index;
                final percentage = distribution[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Text(
                          '$starCount',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: TColors.textSecondary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: isDark ? TColors.darkContainer : TColors.softGrey, // 'bg-background-dim'
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: percentage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: TColors.primary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${(percentage * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: TColors.textSecondary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
