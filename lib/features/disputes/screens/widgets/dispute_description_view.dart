import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisputeDescriptionView extends StatelessWidget {
  final String description;

  const DisputeDescriptionView({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2c2b14) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Description', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFFf8f8f5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              description,
              style: GoogleFonts.inter(fontSize: 16, color: isDark ? Colors.grey[300] : const Color(0xFF1c1c0d), height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          Text('EVIDENCE UPLOADED', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
                ),
                child: Icon(Icons.chat_bubble, color: Colors.grey[400]),
              ),
              const SizedBox(width: 8),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuAzucNrIS2_iXGkQHQ_XHkM_IQy6V2kHcLIZprpx38B_QtDcT7a-SZpH-JD24cuP3zeQ0A8wHJHDz0fT9hYMX5qqfUHrM-0HIzvCX3X39vy6pYFnnlY8PiwCIw6xkHAD34PMOwLBYQLBNY80WqHj5utY9Tstgcc2h5CGlqsm1-jf3oEglCqzzWrNb8LW58hxULG7bhGZrWmpdMKxjtNkpc6Aob1po5y09Cu1pd8JHPV62tFqQOtO2tKE5k-99S4uy7wrhUf3we-bqgp'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
