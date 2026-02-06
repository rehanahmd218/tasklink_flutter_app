import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';
import 'package:tasklink/features/profile/screens/widgets/portfolio_card.dart';
import 'package:tasklink/features/profile/screens/widgets/profile_header.dart';
import 'package:tasklink/features/profile/screens/widgets/profile_stat_card.dart';
import 'package:tasklink/features/profile/screens/widgets/review_card.dart';
import '../../../../utils/constants/colors.dart';
import '../../settings/screens/settings_screen.dart';
import 'edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Profile',
        showBackButton: false,
        actions: [
          IconButton(icon: Icon(Icons.settings, color: isDark ? Colors.white : Colors.black), onPressed: () => Get.to(() => const SettingsScreen())),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            // Header
            ProfileHeader(
              isDark: isDark,
              onEditProfile: () => Get.to(() => const EditProfileScreen()),
              onShare: () {},
            ),
            
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ProfileStatCard(value: '12', label: 'Posted', isDark: isDark),
                  const SizedBox(width: 12),
                  ProfileStatCard(value: '45', label: 'Done', isDark: isDark),
                  const SizedBox(width: 12),
                  ProfileStatCard(value: '4.8', label: 'Rating', isDark: isDark, isRating: true),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[100], indent: 16, endIndent: 16),
            ),
            
            // Portfolio
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Portfolio', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      TextButton(onPressed: () {}, child: Text('See All', style: GoogleFonts.inter(color: Colors.grey[500]))),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      PortfolioCard(
                        title: 'Furniture Assembly',
                        subtitle: 'Jan 15 • Living Room Set',
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDJ-YwRF1G1Ih8jnJEtV8ElPHPyWnGiu0KaA-33Ds9ARYFM5YZclWsfvimqmvSJRnlB4_jigjirARF0JAG8RVycO250MONAU3463QY1Ps4m2BX5QtXe8fsLLrJ5dixi3rIl4YIJ9QUBv2lRcbf7bpkQcQ44pnpv9Ph1s5ci3r7RrnsqRCn8my3AVgvmhcHX4CGuJVrlwZVNz3pjULVi3_N7HQtItLfONV_5PDWRoB93mA0fGeJAHj_gqRJqjXBJ-uPqaClLslf2X6-X',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      PortfolioCard(
                        title: 'Garden Cleanup',
                        subtitle: 'Feb 02 • Backyard Maintenance',
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBtAvG6fyIOPIzjb8-Y4hyQ0amt4opKWKG74GF3RwX6BsCdbxOYq7jAhXZ-gNlcsoxqFp6iOmBmWXvX2dHBgvwGvwsShVoJO-i7vdJ8x77JYboGzv6MQaDPb2KZuRLm6hTdv-eS_xV89w6TGvvgDa2dFDVtj6beelDU6aJTb_iRsAF5fphHfjYcxoOwz5utxeZsCXgzYz-GNLoDjCJ81vHVQLo2MPQB7xZfn-tOQ0OLunIsZzR3jv_EWS2hZPS7i4QwhhoJ85l7ucJK',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      PortfolioCard(
                        title: 'Moving Help',
                        subtitle: 'Mar 10 • 2 Bedroom Apt',
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBjyz6tja3jRtKuwB44yXw03k44UvNU4szvRZezG_dIMlA9pQecRgicQAuo4kRGQb0oLrExYO6nktJt0IpLVukMs4VvYaPepvvrtBKA4TEs-jwPSjjSl_po8mYfuWbAZWN3d2XewPxdoEEPMkhvFvMtcc2UooCwDxHav6qWIsPkud164HTo8DIm3RzC9AiPoyrwbkOf2UbVk7Z2RDi55zvmrFnaEPYzPoP3iOn9f1JWTM1fUbFYcb1ny6OZHwFW355vd4ToOH7lP7tr',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Reviews
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reviews', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: TColors.primary, size: 18),
                          const SizedBox(width: 4),
                          Text('4.8', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                          Text(' (42)', style: GoogleFonts.inter(color: Colors.grey[500])),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   padding: const EdgeInsets.symmetric(horizontal: 16),
                   children: [
                     ReviewCard(
                       name: 'Sarah M.',
                       rating: 5,
                       review: "Great work, very fast! Alex assembled my IKEA wardrobe in record time. Highly recommended.",
                       time: '2 days ago',
                       avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAi1X6qa_rL3glOHbfavJ_1_gNQQTbEkvNbF4Ip8KanveeVDaxZJu-PsaaFIABDsFY3-ZW46TRqYxHnWEpVe3cY7DQPR3F1bh_5l6ZkNcSlYEacyzyG3GJeOusFMT87qptn4PRmSHnQN1S6XXctsQEUEKWl807DZ3y-AzijJVo5B9CvZg3ZdiHUMm1ePnQG6y5pHFThdpLPUqvSIFMxXkxuZA-tibsFYuha0Sp1evWSV_2NIw-PFC9eBH_ya4kMfzur_Lgzj6YoODaa',
                       isDark: isDark,
                     ),
                     ReviewCard(
                       name: 'John D.',
                       rating: 4.5,
                       review: "Arrived on time and was polite. The job was a bit more complex than expected but he handled it well.",
                       time: '1 week ago',
                       avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB3ZiCsq8OaHqo2GzLKpCVUy4mnKe3Fj4vPXbYxeVgNjG1GpnBw1rVcqQTbXKaOoI8FHyDyHA5p7mbrUF9zE-OVSL9fmOsRAS-5SPTRhcTdk4f3zW_XIdfIDnIzGZPmbLyXo8_okxWiqklo1oq_dmKxnQaKBK97EPCsIXzTSmQZP29N_YEN5FUTBWS4GbYJGRL9pRYf-30KvZCqb78UP2ZFqvEWZ5s_kc_nq16-GBPc8DKVmKhaNmkERJXMno9aPk4yFNRfUoRWDPw4',
                       isDark: isDark,
                     ),
                   ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SecondaryButton(
                    onPressed: () {},
                    text: 'Show all 42 reviews',
                    height: 48,
                    borderColor: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
