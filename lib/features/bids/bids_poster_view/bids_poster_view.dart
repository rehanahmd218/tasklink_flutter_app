import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/app_card.dart';
import 'package:tasklink/common/widgets/loaders/empty_state_widget.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/utils/constants/app_colors.dart';

class BidsPosterView extends StatelessWidget {
  final String taskId;
  final String? taskTitle;

  const BidsPosterView({super.key, required this.taskId, this.taskTitle});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BidController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch bids immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBidsForTask(taskId);
    });

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: taskTitle ?? 'Task Bids',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingBids.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.taskBids.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.assignment_outlined,
            title: 'No bids yet',
            subtitle: 'Wait for taskers to bid on your task.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.taskBids.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final bid = controller.taskBids[index];
            return _buildBidCard(context, bid, isDark);
          },
        );
      }),
    );
  }

  Widget _buildBidCard(BuildContext context, BidModel bid, bool isDark) {
    final tasker = bid.tasker;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Tasker Info & Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Avatar & Details
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        AvatarWidget(
                          imageUrl: tasker?.profileImage,
                          initials: tasker?.fullName.isNotEmpty == true
                              ? tasker!.fullName[0].toUpperCase()
                              : '?',
                          size: 56, // w-14 = 3.5rem = 56px
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            tasker?.fullName ?? 'Unknown Tasker',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(
                                context,
                              ).textTheme.titleMedium,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (tasker?.ratingAvg ?? 0.0).toStringAsFixed(1),
                                style: GoogleFonts.inter(
                                  textStyle: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${tasker?.reviewsCount ?? 0} reviews)',
                                style: GoogleFonts.inter(
                                  textStyle: Theme.of(
                                    context,
                                  ).textTheme.bodySmall,
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Bid Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'BID AMOUNT',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${bid.amount.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ), // mb-5 equivalent? HTML has mb-4 then mb-5.
          // Message Section
          if (bid.message != null && bid.message!.isNotEmpty) ...[
            Text(
              '"${bid.message!}"',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontStyle: FontStyle.italic,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Buttons Section
          if (bid.status == 'ACTIVE')
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorderPrimary
                            : AppColors.borderSecondary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Chat logic
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 20,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Chat',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        // View Offer / Accept Logic
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Text(
                          'View Offer',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            // If not active, show status chip centered or similar?
            Center(child: _buildStatusChip(bid.status)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    Color bgColor;

    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        color = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.1);
        break;
      case 'REJECTED':
        color = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.1);
        break;
      case 'ACTIVE':
        color = AppColors.info;
        bgColor = AppColors.info.withValues(alpha: 0.1);
        break;
      default:
        color = AppColors.grey;
        bgColor = AppColors.grey.withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
