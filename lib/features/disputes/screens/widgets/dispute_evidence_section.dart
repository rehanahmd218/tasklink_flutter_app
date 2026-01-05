import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisputeEvidenceSection extends StatelessWidget {
  const DisputeEvidenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Evidence (Optional)', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[200] : const Color(0xFF1c1c0d))),
            Text('Max 5 photos', style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey[400] : const Color(0xFF9e9d47))),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Add Photo Button
              Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2d2c18) : const Color(0xFFf8f8f5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF44432d) : const Color(0xFFe9e8ce), style: BorderStyle.none),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: isDark ? Colors.grey[400] : const Color(0xFF9e9d47)),
                    const SizedBox(height: 4),
                    Text('Add Photo', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[400] : const Color(0xFF9e9d47))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Pre-filled Image Example
              Stack(
                children: [
                  Container(
                    width: 96, height: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? const Color(0xFF44432d) : const Color(0xFFe9e8ce)),
                      image: const DecorationImage(
                        image: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuD0OTXc2bi0HqLvCZ_VZiuXHykDkFMea-cqXCljcZQcrUGnng6BBKeA21NNeGDg4hZzSdt52n2wqgaXeS4qDCRfcQmKuxOmBsbnJejxPnIla2JI46RJrWPvfQl2XdqKiGJWGGMQm9Dbk-LwRLji3EE5hS4Y5xz19_7VAmvpsmsqi1olLoxTQYwS55xxB-UU5Z4faXgTx0EyX-VRDVKFE3YGDycUVB_0qMSj9UeYHAlC-eYxYUf0BGStjJSawCHmg6NfpfvbswQDmJpl'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0, right: 0,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.red, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
