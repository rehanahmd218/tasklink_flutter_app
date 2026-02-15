import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/app_card.dart';
import 'package:tasklink/common/widgets/loaders/empty_state_widget.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/utils/constants/app_colors.dart';

class BidsTaskerView extends StatelessWidget {
  const BidsTaskerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BidController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch my bids on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMyBids();
    });

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'My Bids',
        showBackButton: true,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        // ... (body content remains)
        if (controller.isLoadingBids.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.myBids.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.gavel_outlined,
            title: 'No bids placed yet',
            subtitle: 'Start browsing tasks and place your first bid!',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.myBids.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final bid = controller.myBids[index];
            return _buildMyBidCard(context, bid, isDark);
          },
        );
      }),
    );
  }

  Widget _buildMyBidCard(BuildContext context, BidModel bid, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon, Title, Posted By, Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.2,
                  ), // bg-primary/20
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons
                        .handyman_outlined, // Fallback for 'plumbing'/'handyman'
                    size: 28,
                    color: isDark
                        ? AppColors.primary
                        : Colors.black, // darker icon color
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and Poster
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid.taskTitle ?? 'Unknown Task',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Posted by Client', // Placeholder as data is missing
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Status Chip
              _buildStatusChip(bid.status, isDark),
            ],
          ),

          const SizedBox(height: 12),

          // Middle Row: Bid & Budget
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: isDark
                      ? AppColors.darkBorderPrimary
                      : AppColors.borderSecondary,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Your Bid
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR BID',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${bid.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                // Task Budget
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TASK BUDGET',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // Placeholder range based on bid amount to simulate budget
                      '\$${(bid.amount * 0.9).floor()} - \$${(bid.amount * 1.2).ceil()}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bottom Row: Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
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
                          size: 18,
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
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      // View Task logic
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Text(
                        'View Task',
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isDark) {
    Color textColor;
    Color bgColor;
    String label = status.toUpperCase();

    // Map status to visual design
    if (status.toUpperCase() == 'ACTIVE') {
      textColor = isDark
          ? AppColors.darkTextSecondary
          : AppColors.textSecondary; // neutral-600
      bgColor = isDark
          ? AppColors.darkContainer
          : AppColors.softGrey; // neutral-100
      label = 'PENDING';
    } else if (status.toUpperCase() == 'ACCEPTED') {
      textColor = AppColors.success;
      bgColor = AppColors.success.withValues(alpha: 0.1);
    } else if (status.toUpperCase() == 'REJECTED') {
      textColor = AppColors.error;
      bgColor = AppColors.error.withValues(alpha: 0.1);
    } else {
      textColor = AppColors.grey;
      bgColor = AppColors.grey.withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100), // full rounded
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
