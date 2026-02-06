import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/buttons/app_button.dart';
import 'package:tasklink/controllers/features/task_details_tasker_controller.dart';
import '../widgets/safe_payment_warning.dart';
import '../widgets/task_detail_card.dart';
import '../widgets/task_location_card.dart';
import '../widgets/task_map_preview.dart';
import '../widgets/task_poster_profile.dart';

class TaskDetailsTaskerScreen extends StatelessWidget {
  const TaskDetailsTaskerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskDetailsTaskerController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(top: 48, bottom: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: (isDark ? TColors.backgroundDark : TColors.backgroundLight).withValues(alpha: 0.8),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Get.back(),
                      size: 40,
                      backgroundColor: Colors.transparent,
                      iconColor: isDark ? TColors.white : TColors.textPrimary,
                    ),
                    Text(
                      'Task Details',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? TColors.white : TColors.textPrimary,
                      ),
                    ),
                    AppIconButton(
                      icon: Icons.share,
                      onPressed: controller.shareTask,
                      size: 40,
                      backgroundColor: Colors.transparent,
                      iconColor: isDark ? TColors.white : TColors.textPrimary,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120), // Space for footer
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: TColors.primary,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2),
                                    ],
                                  ),
                                  child: Obx(() => Text(
                                    controller.priceRange.value,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  )),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? TColors.darkContainer : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.history_toggle_off, size: 16, color: TColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Obx(() => Text(
                                        controller.postedTime.value,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: TColors.textSecondary,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Obx(() => Text(
                              controller.taskTitle.value,
                              style: GoogleFonts.inter(
                                fontSize: 28, // 3xl
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -0.5,
                                color: isDark ? TColors.white : TColors.textPrimary,
                              ),
                            )),
                            const SizedBox(height: 24),
                            
                            // Poster Profile
                            Obx(() => TaskPosterProfile(
                              name: controller.posterName.value,
                              avatarUrl: controller.posterAvatar.value,
                              rating: controller.posterRating.value,
                              reviews: controller.posterReviews.value,
                            )),
                          ],
                        ),
                      ),
                      
                      // Key Details Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Obx(() => TaskDetailCard(
                                  icon: Icons.calendar_today, 
                                  label: 'Date & Time', 
                                  value: controller.date.value, 
                                  color: Colors.blue
                                ))),
                                const SizedBox(width: 12),
                                Expanded(child: Obx(() => TaskDetailCard(
                                  icon: Icons.category, 
                                  label: 'Category', 
                                  value: controller.category.value, 
                                  color: Colors.orange
                                ))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Obx(() => TaskLocationCard(location: controller.location.value)),
                          ],
                        ),
                      ),
                      
                      // Description
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.description, color: TColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'Description',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? TColors.white : TColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? TColors.darkContainer : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Obx(() => Text(
                                controller.description.value,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: isDark ? Colors.grey[300] : TColors.textSecondary,
                                ),
                              )),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Center(child: Text('Show more', style: TextStyle(color: TColors.textSecondary))),
                            ),
                          ],
                        ),
                      ),

                      // Map Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(() => TaskMapPreview(mapImageUrl: controller.mapImageUrl.value)),
                      ),
                      
                      // Safety Warning
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: SafePaymentWarning(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Sticky Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? TColors.backgroundDark : TColors.white,
                border: Border(top: BorderSide(color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -4))
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pay out and button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESTIMATED PAYOUT',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: TColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Obx(() => Text(
                                controller.priceRange.value,
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? TColors.white : TColors.textPrimary,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Place a Bid',
                      icon: Icons.gavel,
                      onPressed: controller.placeBid,
                      height: 56,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}
