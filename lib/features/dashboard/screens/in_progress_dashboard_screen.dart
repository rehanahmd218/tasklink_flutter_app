import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/app_button.dart';
import 'package:tasklink/common/widgets/app_card.dart';
import 'package:tasklink/controllers/features/in_progress_dashboard_controller.dart';
import 'widgets/status_stepper.dart';
import 'widgets/task_evidence_gallery.dart';

class InProgressDashboardScreen extends StatelessWidget {
  const InProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InProgressDashboardController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? TColors.darkContainer : TColors.white,
        elevation: 0,
        leading: AppIconButton(
          icon: Icons.arrow_back_ios_new,
          onPressed: () => Get.back(),
          size: 40,
          backgroundColor: Colors.transparent,
        ),
        title: Obx(() => Text(
          controller.taskTitle.value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? TColors.white : TColors.textPrimary,
          ),
        )),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Obx(() => Text(
                '\$${controller.taskPrice.value}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.primary : Colors.brown, // 'text-yellow-600' approx
                ),
              )),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const StatusStepper(),
                  
                  // Info Box
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF3F3D00) : const Color(0xFFFEFCE8), // yellow-50/yellow-900/10
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? const Color(0xFF5C5900) : const Color(0xFFFEF08A), // yellow-100
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info, color: isDark ? Colors.yellow[400] : Colors.yellow[700], size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Task Started',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.yellow[200] : Colors.yellow[900],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tasker started work at 10:30 AM. Please stay available for any questions.',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isDark ? Colors.yellow[100] : Colors.yellow[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Chat Action
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AppCard(
                      onTap: controller.openChat,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              const AvatarWidget(
                                initials: 'A', // Fallback
                                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDgnmAeVKo3FW9nNT5uYg9OPCPcxGbF9Qbarfjxx0BPLbyHw4sn7aucQyRY2Bbvzou0t3Azku0P4IoWimTX2KEWd2yUowX0w1lMat0gyC_Oq3pyNHLVWfzuO-EniNwYL6Shf2h1wOO7WriVRJBq7fGI1DCgWJWEsl2tePkDTjY4eX4ABCQ_Rquj7Ri9_X3zt1atpHgHIECI87NVWQoxVUNKxclNUZixqNIW2KoiRd0u53TqGv-u-gBdEw-6-wEANcpolddxHXVifmp5',
                                size: 40,
                                isOnline: true,
                                showOnlineIndicator: true,
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Text(
                                  'Chat with ${controller.taskerName.value}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? TColors.white : TColors.textPrimary,
                                  ),
                                )),
                                Obx(() => Text(
                                  controller.chatPreview.value,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: TColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ],
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: TColors.primary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chat_bubble, color: Colors.brown // yellow-800 approximation
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Task Evidence
                  Obx(() => TaskEvidenceGallery(
                    photos: controller.evidencePhotos,
                    onAddPhoto: controller.addPhoto,
                  )),
                ],
              ),
            ),
          ),
          
          // Sticky Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? TColors.darkContainer : TColors.white,
              border: Border(top: BorderSide(color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary)),
              boxShadow: isDark ? [] : [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -4))
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    text: 'Mark as Completed',
                    icon: Icons.check_circle,
                    onPressed: controller.markAsCompleted,
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: controller.reportIssue,
                    icon: const Icon(Icons.report_problem, size: 16, color: TColors.error),
                    label: Text(
                      'Report an Issue',
                      style: GoogleFonts.inter(
                        color: TColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Use EmptyStateWidget somewhere? Maybe if no evidence? But not needed by design.
    );
  }
}

