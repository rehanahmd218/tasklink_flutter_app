import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/app_card.dart';
import 'package:tasklink/common/widgets/loaders/empty_state_widget.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/services/bids/bid_service.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

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
      if (taskId.isNotEmpty) {
        controller.fetchBidsForTask(taskId);
      }
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1a1a0b) : Colors.white,
      appBar: PrimaryAppBar(
        title: 'All Received Bids',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingBids.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.taskBids.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.gavel_outlined,
            title: 'No Bids Yet',
            subtitle: 'Wait for taskers to place bids on your task.',
          );
        }

        final count = controller.taskBids.length;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(context, count, isDark, controller, taskTitle),
            const SizedBox(height: 20),
            ...List.generate(controller.taskBids.length, (index) {
              final bid = controller.taskBids[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildBidCard(context, bid, isDark),
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int totalBids,
    bool isDark,
    BidController controller,
    String? taskTitle,
  ) {
    return Column(
      children: [
        Center(
          child: Text(
            taskTitle ?? 'Task',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : TColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$totalBids Total Bids',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : TColors.textPrimary,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showSortOptions(context, controller, isDark),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sort,
                        size: 20,
                        color: isDark ? Colors.grey[400] : TColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SORT',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[400] : TColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openChatForBid(BidModel bid, String? taskTitle) async {
    if (bid.tasker == null) return;
    try {
      FullScreenLoader.show(text: 'Opening chat...');
      final room = await BidService().initiateChat(bid.id);
      FullScreenLoader.hide();
      Get.toNamed(
        Routes.CHAT_ROOM,
        arguments: {
          'roomId': room.id,
          'otherUser': bid.tasker,
          'taskTitle': taskTitle ?? room.displayTitle,
        },
      );
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  void _showSortOptions(BuildContext context, BidController controller, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF23220f) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort by',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : TColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Amount (low to high)'),
                onTap: () {
                  controller.sortTaskBidsByAmount(ascending: true);
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Amount (high to low)'),
                onTap: () {
                  controller.sortTaskBidsByAmount(ascending: false);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBidCard(BuildContext context, BidModel bid, bool isDark) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(
                  bid.tasker!.profileImage ?? 'https://via.placeholder.com/150',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid.tasker!.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : TColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: TColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bid.tasker!.ratingAvg.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : TColors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${bid.tasker!.reviewsCount} reviews)',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey[400]
                                : TColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${bid.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : TColors.black,
                    ),
                  ),
                  Text(
                    'Offered',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark
                          ? Colors.grey[400]
                          : TColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (bid.message != null && bid.message!.isNotEmpty) ...[
            Text(
              bid.message!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : TColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  onPressed: () => _openChatForBid(bid, taskTitle),
                  text: 'Chat',
                  icon: Icons.chat_bubble_outline,
                  height: 48,
                  fontSize: 14,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  onPressed: () {
                    Get.toNamed(
                      Routes.BID_MANAGEMENT,
                      arguments: {
                        'bid': bid,
                        'isPoster': true,
                        'taskId': taskId,
                        'taskTitle': taskTitle,
                      },
                    );
                  },
                  text: 'View Offer',
                  height: 48,
                  fontSize: 14,
                  borderRadius: 12,
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
