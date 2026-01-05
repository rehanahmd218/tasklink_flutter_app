import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class ReviewRatingSection extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingUpdate;

  const ReviewRatingSection({
    super.key,
    required this.rating,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(Icons.star, color: TColors.primary),
          onRatingUpdate: onRatingUpdate,
        ),
        const SizedBox(height: 8),
        Text(
          rating >= 4 ? 'Good' : (rating >= 3 ? 'Average' : 'Poor'),
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: TColors.tertiary),
        ),
      ],
    );
  }
}
