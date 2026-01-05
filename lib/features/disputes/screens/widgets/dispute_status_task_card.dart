import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisputeStatusTaskCard extends StatelessWidget {
  const DisputeStatusTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: Text('RELATED TASK', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF1c1c0d).withValues(alpha: 0.6), letterSpacing: 0.5))),
            const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2c2b14) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
          ),
          child: Row(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuDQA3Jo628X8f9qFoioGJPBkEfWDLI0V3km1Elp0Mel7TClP18BKxE9Pm41ueOPaAw_UMz1xjhthjka-KB0xumbJXYcxOtmw_1pAn0FVPn6rU54JL_l2qJf3qNRaC1KHUSzdOQ-zeRoQ8dRzl43HpMebT-62fjcwZ7UyXaQQRg44BRk9z2Fc2U1cFyVQcb7mJBeHwzleFp7Ikg0Qq9LjGfrfLrPFY3keKiRo2cfwv_AbEkY7YlvgEEAdBHae_TVhWInYy-ix0nRaXgY'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Lawn Mowing - Front & Back', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                        Text('\$50.00', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                      ],
                    ),
                    Text('Oct 24, 2023 • 2:00 PM', style: GoogleFonts.inter(fontSize: 14, color: isDark ? const Color(0xFFcfce97) : const Color(0xFF9e9d47))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Tasker:', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 4),
                        const CircleAvatar(
                          radius: 8,
                          backgroundImage: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuAFZbDv8E4pyqHTRFSw-fl5pRE2f40nLBM0plPGyn3ieI5BxdcQPiOettheZrDro-pAKaKUkqNdogiXkAOCLSqYXssw1JGJGHob0Ef7NsjFC3Nj4cRbAC_xuUEDMruF3CGPGMWrk6ijH-WPu0ezMlspGfHB1TBZ319qXhPDvu-MyJIjs1_iU5GNv2UGid62e3lplKaIsDyhzmmBddhemtR363osjtO-nccxG_rwlbckFhAL89Wmdo7u1qsRMk2Gsl95EV9Hpxt-4Aze'),
                        ),
                        const SizedBox(width: 4),
                        Text('Alex M.', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
