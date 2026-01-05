import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/bottom_nav_bar.dart';
import 'package:tasklink/controllers/features/ratings_controller.dart';
import 'widgets/rating_summary.dart';
import 'widgets/review_card.dart';
import 'widgets/role_toggle_widget.dart';

class CompleteRatingsScreen extends StatelessWidget {
  const CompleteRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RatingsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      body: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const PrimaryAppBar(
              title: 'Reviews',
            ),
            body: Column(
            children: [
              // Header


              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Obx(() => RatingSummary(
                        averageRating: controller.averageRating.value,
                        totalReviews: controller.totalReviews.value,
                        distribution: controller.distribution,
                      )),
                    ),
                    
                    SliverPersistentHeader(
                      delegate: _StickyHeaderDelegate(
                        child: Obx(() => RoleToggleWidget(
                          selectedRole: controller.selectedRole.value,
                          onRoleSelected: controller.toggleRole,
                        )),
                      ),
                      pinned: true,
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 80),
                      sliver: Obx(() => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ReviewCard(review: controller.reviews[index]);
                          },
                          childCount: controller.reviews.length,
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
          
          // Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavBar(
              currentIndex: 4, // Profile tab active? HTML doesn't specify, but reviews usually under profile.
              onTap: (index) {
                // Navigation logic
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 64; // Height of RoleToggleWidget container + padding (48 + 16 approx)

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

