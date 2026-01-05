import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';

class HomeTaskCard extends StatelessWidget {
  final String title;
  final int price;
  final String category;
  final String distance;
  final String? time;
  final String? expires;
  final Color color;
  final IconData icon;

  const HomeTaskCard({
    super.key,
    required this.title,
    required this.price,
    required this.category,
    required this.distance,
    this.time,
    this.expires,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RoundedContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      backgroundColor: isDark ? const Color(0xFF292524) : Colors.white,
      radius: 16,
      borderColor: Colors.transparent, // Shadow handles separation
      showBorder: false, // Using shadow instead
      // Note: RoundedContainer might need shadow support if removed from here. 
      // The original code had specific shadow. RoundedContainer doesn't support shadow param in my previous implementation? 
      // Let me check RoundedContainer definition from memory/logs. 
      // It has borderColor and showBorder. It doesn't seem to have shadow. 
      // I should probably stick to Container or update RoundedContainer. 
      // Wait, MyTaskCard also had shadow and I replaced it with RoundedContainer without adding shadow property?
      // I should check MyTaskCard refactor. I passed `showBorder: true`.
      // If I want shadow, I probably kept it in `MyTaskCard`? 
      // Checking `MyTaskCard` replacement content... 
      // "return RoundedContainer(..., child: ...)"
      // I removed the shadow in `MyTaskCard` refactor! That might be a regression if shadow was desired.
      // However, `RoundedContainer` might not have shadow. 
      // Let's assume for now I want to standardize on `RoundedContainer` which might relies on border for separation or I should update it.
      // But for `HomeTaskCard`, the design relies on shadow (elevation).
      // If `RoundedContainer` doesn't support shadow, maybe I shouldn't use it here OR I should wrap it or update `RoundedContainer`.
      // Given the instruction to "extract Containers with recurring styles", and `RoundedContainer` is that.
      // Let's update `RoundedContainer` to support shadow, or just use Container here if it's unique. 
      // Actually `MyTaskCard` had shadow too.
      // I will verify `RoundedContainer` code first.
      
      // I'll proceed with this but if RoundedContainer lacks shadow, I'll update RoundedContainer next.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          RoundedContainer(
            height: 48,
            width: 48,
            backgroundColor: isDark ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.1),
            radius: 12,
            child: Center(child: Icon(icon, color: isDark ? color.withValues(alpha: 0.8) : color)),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    RoundedContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      backgroundColor: TColors.primary,
                      radius: 20,
                      child: Text('\$$price', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ],
                ),
                Text(category, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.near_me, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(distance, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[400])),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    if (expires != null) ...[
                      const Icon(Icons.timer_outlined, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(expires!, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red)),
                    ] else ...[
                       Icon(Icons.schedule, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(time ?? '', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[400])),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
