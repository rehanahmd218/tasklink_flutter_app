import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/notifications/screens/notifications_screen.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/home_controller.dart';
import 'home_search_bar.dart';
import 'home_view_toggle.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? TColors.backgroundDark : TColors.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Location & Notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   const Icon(Icons.location_on, color: TColors.primary, size: 26),
                   const SizedBox(width: 6),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'CURRENT LOCATION',
                         style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: TColors.textSecondary, letterSpacing: 0.5),
                       ),
                       Row(
                         children: [
                           Text(
                             'San Francisco, CA', // Or Downtown, NY based on design variance
                             style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : TColors.textPrimary),
                           ),
                           const Icon(Icons.expand_more, size: 20),
                         ],
                       )
                     ],
                   )
                ],
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.notifications_outlined, color: isDark ? Colors.white : Colors.black87, size: 24),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Get.to(() => const NotificationsScreen()),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? TColors.backgroundDark : Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Search Bar
          const HomeSearchBar(),
          
          const SizedBox(height: 16),
          
          // Toggle Segmented Control
          const HomeViewToggle(),
        ],
      ),
    );
  }
}
