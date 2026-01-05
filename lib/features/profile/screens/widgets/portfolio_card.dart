import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PortfolioCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isDark;

  const PortfolioCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 256,
          height: 144,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: CachedNetworkImageProvider(imageUrl), fit: BoxFit.cover),
            color: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
        Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }
}
