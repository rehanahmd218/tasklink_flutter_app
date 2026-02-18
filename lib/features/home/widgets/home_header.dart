import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/notifications/screens/notifications_screen.dart';
import 'package:tasklink/features/profile/screens/profile_screen.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/home_controller.dart';
import 'home_search_bar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = UserController.instance.currentUser;
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
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: TColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENT LOCATION',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: TColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Obx(
                            () {
                              final controller = Get.find<HomeController>();
                              final text = controller.locationLabel.value.isEmpty
                                  ? 'Getting location...'
                                  : controller.locationLabel.value;
                              return Text(
                                text,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : TColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.transparent,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: isDark ? Colors.white : Colors.black87,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () =>
                                Get.to(() => const NotificationsScreen()),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? TColors.backgroundDark
                                  : Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Get.to(() => const ProfileScreen()),
                    child: Obx(
                      () => Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              currentUser.value?.profile?.profileImage ??
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAr3fJTn31zIPtg9-Tv0QHdbWvknBuARuDIjSA5t5EFgvHq1sUl7D8hfxJjYCwJTGl7DjKXozw1HsXxn1mae5APm3GUtjCmpMDGmOZnFpXlwzEV1gJA7ANhfm4fzxhNq2_cMPrwAWTcg1JH9q1GuNFaSU-OnMMohDyi89ZyiHLMnntVoYptWi7BP2WA__zWMaDvOTbhAJfhUzt_93rSAByT0MWzbfVldfspKBW7MgUbRqogGeYMor8Em4fdWCnWyWgE35LarultZGkR',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search Bar
          const HomeSearchBar(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
