import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../utils/constants/colors.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final double rating;
  final String review;
  final String time;
  final String avatarUrl;
  final bool isDark;

  const ReviewCard({
    super.key,
    required this.name,
    required this.rating,
    required this.review,
    required this.time,
    required this.avatarUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2d2c1b) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 16, backgroundImage: CachedNetworkImageProvider(avatarUrl)),
                  const SizedBox(width: 12),
                  Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                ],
              ),
              Row(children: List.generate(5, (index) => Icon(Icons.star, size: 18, color: index < rating ? TColors.primary : Colors.grey[300]))),
            ],
          ),
          const SizedBox(height: 8),
          Text(review, style: GoogleFonts.inter(fontSize: 14, color: isDark ? Colors.grey[300] : Colors.grey[600], height: 1.5)),
          const SizedBox(height: 8),
          Text(time, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[400])),
        ],
      ),
    );
  }
}
