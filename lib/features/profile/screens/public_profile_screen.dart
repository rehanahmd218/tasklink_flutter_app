import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/ratings_controller.dart';
import 'package:tasklink/features/ratings/screens/widgets/rating_summary.dart';
import 'package:tasklink/features/ratings/screens/widgets/review_card.dart';
import 'package:tasklink/features/ratings/screens/widgets/role_toggle_widget.dart';
import 'package:tasklink/models/user/public_profile_model.dart';
import 'package:tasklink/services/user/user_service.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Public profile: header (avatar, name, rating, reviews count) + reviews section only.
/// No settings, no edit profile, no personal information.
class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  String? _userId;
  PublicProfileModel? _profile;
  bool _loading = true;
  String? _error;
  static const String _placeholderAvatar =
      'https://ui-avatars.com/api/?name=User&size=128';

  @override
  void initState() {
    super.initState();
    _userId = Get.arguments is Map ? Get.arguments['userId']?.toString() : null;
    if (_userId == null || _userId!.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'User not specified.';
      });
      return;
    }
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await UserService().getPublicProfile(_userId!);
      setState(() {
        _profile = profile;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: const PrimaryAppBar(
        title: 'Profile',
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Go back'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(isDark),
                      const SizedBox(height: 24),
                      _buildReviewsSection(isDark),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final p = _profile!;
    final imageUrl = p.profileImage?.isNotEmpty == true
        ? p.profileImage!
        : _placeholderAvatar;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFF2d2c1b) : Colors.white,
                width: 4,
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.person, size: 64),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            p.displayName,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: TColors.primary, size: 20),
              const SizedBox(width: 4),
              Text(
                p.ratingAvg.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                ' (${p.reviewsCount} reviews)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(bool isDark) {
    final controller = Get.put(RatingsController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Reviews',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        Container(
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
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: RoleToggleWidget(
            selectedRole: controller.selectedRole.value,
            onRoleSelected: controller.toggleRole,
          ),
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (controller.reviews.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No reviews yet.',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.reviews.length,
            itemBuilder: (_, i) {
              return ReviewCard(review: controller.reviews[i]);
            },
          );
        }),
      ],
    );
  }
}
