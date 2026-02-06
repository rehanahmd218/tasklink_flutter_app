import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';

class TaskBidCard extends StatelessWidget {
  final String name;
  final int price;
  final String imageUrl;
  final String message;

  const TaskBidCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RoundedContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: CachedNetworkImageProvider(imageUrl)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                           Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                           const SizedBox(width: 4),
                           const Icon(Icons.verified, size: 14, color: Colors.blue),
                        ],
                      ),
                      Row(
                         children: [
                           const Icon(Icons.star, size: 14, color: TColors.primary),
                           Text('4.9', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                           Text(' (124 tasks)', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
                         ],
                      ),
                    ],
                  ),
                ],
              ),
              Text('\$$price', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message, style: GoogleFonts.inter(fontStyle: FontStyle.italic, color: Colors.grey[600], fontSize: 13)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  onPressed: () {},
                  text: 'Reject',
                  icon: Icons.close,
                  foregroundColor: Colors.grey[700],
                  borderColor: Colors.grey[300]!,
                  height: 48,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  onPressed: () {},
                  text: 'Accept Offer',
                  icon: Icons.check,
                  borderRadius: 12,
                  height: 48,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
