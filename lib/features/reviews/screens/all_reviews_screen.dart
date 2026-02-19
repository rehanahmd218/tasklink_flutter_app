import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/ratings_controller.dart';
import 'package:tasklink/features/ratings/screens/widgets/rating_summary.dart';
import 'package:tasklink/features/ratings/screens/widgets/review_card.dart';
import 'package:tasklink/features/ratings/screens/widgets/role_toggle_widget.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// All reviews screen matching the "Complete Ratings View" design:
/// header, rating summary with bars, As Tasker/As Poster toggle, review list.
/// No bottom navigation. Reuses [RatingSummary], [RoleToggleWidget], [ReviewCard].
class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RatingsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : const Color(0xFFfcfcf8),
      appBar: const PrimaryAppBar(
        title: 'Reviews',
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.loadError.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.loadError.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => controller.loadReviews(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? TColors.darkBorderPrimary
                                : const Color(0xFFe9e8ce).withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      child: Obx(
                        () => RatingSummary(
                          averageRating: controller.averageRating.value,
                          totalReviews: controller.totalReviews.value,
                          distribution: controller.distribution,
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _StickyHeaderDelegate(
                      child: Container(
                        color: isDark
                            ? TColors.backgroundDark
                            : const Color(0xFFfcfcf8),
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: Obx(
                          () => RoleToggleWidget(
                            selectedRole: controller.selectedRole.value,
                            onRoleSelected: controller.toggleRole,
                          ),
                        ),
                      ),
                    ),
                    pinned: true,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: Obx(
                      () {
                        if (controller.reviews.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  'No reviews yet.',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ReviewCard(
                                review: controller.reviews[index],
                              );
                            },
                            childCount: controller.reviews.length,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 88;

  @override
  double get minExtent => 88;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
