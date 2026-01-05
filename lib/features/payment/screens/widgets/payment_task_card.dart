import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../utils/constants/colors.dart';

class PaymentTaskCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String postId;

  const PaymentTaskCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            bottom: 16, left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: TColors.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.handyman, size: 16, color: Colors.black),
                      const SizedBox(width: 4),
                      Text('FURNITURE ASSEMBLY', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Post ID: #$postId', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
