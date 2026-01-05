import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/common/widgets/secondary_button.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';

class MyTaskCard extends StatelessWidget {
  final String title;
  final String price;
  final String status;
  final Color statusColor;
  final String due;
  final String description;
  final String posterName;
  final String location;
  final String avatarUrl;
  final String primaryAction;
  final String secondaryAction;
  final bool isPrimaryActionDark;

  const MyTaskCard({
    super.key,
    required this.title,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.due,
    required this.description,
    required this.posterName,
    required this.location,
    required this.avatarUrl,
    required this.primaryAction,
    required this.secondaryAction,
    this.isPrimaryActionDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RoundedContainer(
      backgroundColor: isDark ? const Color(0xFF27272a) : const Color(0xFFfcfcf8),
      borderColor: isDark ? Colors.grey[800] : Colors.grey[100],
      showBorder: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(status.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                  ),
                  const SizedBox(width: 8),
                  Text(due, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Text(price, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 4),
          Text(description, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: CachedNetworkImageProvider(avatarUrl)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Poster: $posterName', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black)),
                  Text(location, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  onPressed: () {},
                  text: primaryAction,
                  icon: Icons.chat_bubble_outline,
                  height: 48, // Match approximate height of previous button
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SecondaryButton(
                  onPressed: () {},
                  text: secondaryAction,
                  backgroundColor: isPrimaryActionDark ? Colors.white : Colors.transparent,
                  foregroundColor: isPrimaryActionDark ? Colors.black : (isDark ? Colors.white : Colors.black),
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
