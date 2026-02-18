import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/controllers/features/profile_reviews_controller.dart';
import 'package:tasklink/features/profile/screens/widgets/profile_header.dart';
import 'package:tasklink/features/profile/screens/widgets/profile_stat_card.dart';
import 'package:tasklink/features/profile/screens/widgets/review_card.dart';
import 'package:tasklink/features/profile/screens/widgets/personal_information_section.dart';
import '../../../../utils/constants/colors.dart';
import '../../settings/screens/settings_screen.dart';
import 'edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userController = UserController.instance;
    final reviewsController = Get.put(ProfileReviewsController());
    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Profile',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await UserController.instance.fetchUserProfile();
          await Get.find<ProfileReviewsController>().load();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
          children: [
            // Header
            ProfileHeader(
              isDark: isDark,
              onEditProfile: () => Get.to(() => const EditProfileScreen()),
              // onShare: () {},
            ),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Obx(
                    () => ProfileStatCard(
                      value:
                          userController.currentUser.value?.totalTasksPosted
                              .toString() ??
                          '0',
                      label: 'Posted',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => ProfileStatCard(
                      value:
                          userController.currentUser.value?.totalTasksCompleted
                              .toString() ??
                          '0',
                      label: 'Done',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => ProfileStatCard(
                      value:
                          userController.currentUser.value?.ratingAvg
                              .toString() ??
                          '0',
                      label: 'Rating',
                      isDark: isDark,
                      isRating: true,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                indent: 16,
                endIndent: 16,
                height: 1,
              ),
            ),

            // Personal Information Section
            PersonalInformationSection(isDark: isDark),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                indent: 16,
                endIndent: 16,
                height: 1,
              ),
            ),

            // Reviews
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reviews',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Obx(() {
                        final rating = userController.currentUser.value?.ratingAvg;
                        final count = reviewsController.totalCount.value > 0
                            ? reviewsController.totalCount.value
                            : userController.currentUser.value?.reviewsCount ?? 0;
                        return Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: TColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating?.toStringAsFixed(1) ?? '0',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              ' ($count)',
                              style: GoogleFonts.inter(color: Colors.grey[500]),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                Obx(() {
                  if (reviewsController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))),
                    );
                  }
                  final items = reviewsController.firstTwo;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final r = items[i];
                      return ReviewCard(
                        name: r.name,
                        rating: r.rating,
                        review: r.review,
                        time: r.time,
                        avatarUrl: r.avatarUrl,
                        isDark: isDark,
                      );
                    },
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    final count = reviewsController.totalCount.value > 0
                        ? reviewsController.totalCount.value
                        : userController.currentUser.value?.reviewsCount ?? 0;
                    return SecondaryButton(
                      onPressed: () => Get.toNamed(Routes.ALL_REVIEWS, arguments: {}),
                      text: 'Show all $count reviews',
                      height: 48,
                      borderColor: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
