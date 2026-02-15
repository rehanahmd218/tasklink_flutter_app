import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/utils/constants/app_colors.dart';
import 'package:tasklink/utils/formatters/date_formatter.dart';

import 'package:tasklink/common/widgets/buttons/secondary_button.dart';
import 'package:tasklink/features/bids/bid_management/screens/widgets/bid_action_buttons.dart';
import 'package:tasklink/features/bids/bid_management/screens/widgets/bid_amount_display.dart';
import 'package:tasklink/features/bids/bid_management/screens/widgets/bid_pitch_display.dart';
import 'package:tasklink/features/bids/bid_management/screens/widgets/bid_status_chip.dart';
import 'package:tasklink/features/bids/bid_management/screens/widgets/bid_task_preview.dart';

class BidManagementScreen extends StatelessWidget {
  const BidManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final bid = args['bid'] as BidModel?;
    // Optional task model for extra context (e.g. poster info for tasker chat)
    final task = args['task'] as TaskModel?;
    final isPoster = args['isPoster'] as bool? ?? false;

    if (bid == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No bid data provided')),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(BidController());
    final taskId = task?.id ?? bid.task ?? args['taskId'] as String? ?? '';
    final taskTitle =
        task?.title ?? bid.taskTitle ?? args['taskTitle'] as String? ?? 'Task';
    final taskImageUrl = (task != null && task!.media.isNotEmpty)
        ? task!.media.first.file
        : null;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1a1a0b) : Colors.white,
      appBar: PrimaryAppBar(
        title: isPoster ? 'Bid Offer' : 'Manage Bid',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Task tile at top (as in design)
                  if (taskId.isNotEmpty)
                    BidTaskPreview(
                      title: taskTitle,
                      imageUrl: taskImageUrl,
                      onTap: () {
                        Get.toNamed(
                          Routes.TASK_DETAILS,
                          arguments: {'taskId': taskId},
                        );
                      },
                    ),
                  if (taskId.isNotEmpty) const SizedBox(height: 16),

                  // Status Chip
                  BidStatusChip(
                    label: bid.status.replaceAll('_', ' '),
                    backgroundColor: _getStatusColor(bid.status, isDark, true),
                    borderColor: _getStatusColor(bid.status, isDark, false),
                    textColor: _getStatusColor(bid.status, isDark, false),
                    indicatorColor: _getStatusIndicatorColor(bid.status),
                  ),

                  const SizedBox(height: 24),

                  BidAmountDisplay(
                    amount: '\$${bid.amount.toStringAsFixed(2)}',
                    date: TFormatter.formatDate(bid.createdAt),
                  ),

                  const SizedBox(height: 32),

                  // Pitch
                  if (bid.message != null && bid.message!.isNotEmpty)
                    BidPitchDisplay(pitch: bid.message!),

                  if (isPoster) ...[
                    const SizedBox(height: 32),
                    Divider(color: Colors.grey[200]),
                    const SizedBox(height: 16),
                    _buildPosterActions(context, bid, controller),
                  ] else ...[
                    const SizedBox(height: 32),
                    if (bid.status == 'ACTIVE')
                      BidActionButtons(
                        onEdit: () async {
                          if (task != null) {
                            final result = await Get.toNamed(
                              Routes.PLACE_BID,
                              arguments: {'task': task, 'bid': bid},
                            );
                            if (result == true) {
                              Get.back(result: true); // Refresh
                            }
                          } else {
                            Get.snackbar('Error', 'Task details missing');
                          }
                        },
                        onContact: () {
                          if (task != null && task.poster != null) {
                            Get.toNamed(
                              Routes.CHAT_ROOM,
                              arguments: {
                                'taskId': bid.task,
                                'otherUser': task.poster,
                              },
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Cannot chat: Task details missing',
                            );
                          }
                        },
                        onWithdraw: () {
                          Get.defaultDialog(
                            title: 'Withdraw Bid',
                            middleText:
                                'Are you sure you want to withdraw this bid?',
                            textConfirm: 'Withdraw',
                            textCancel: 'Cancel',
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              Get.back(); // Close dialog
                              controller.withdrawBid(bid.id);
                            },
                          );
                        },
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Bid is ${bid.status}',
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterActions(
    BuildContext context,
    BidModel bid,
    BidController controller,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Accept Offer (primary)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final result = await Get.toNamed(
                Routes.PAYMENT,
                arguments: {'taskId': bid.task, 'bid': bid},
              );
              if (result == true) {
                Get.back(result: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
                Text(
                  'Accept Offer',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Chat with Tasker (secondary – styled like design)
        SecondaryButton(
          onPressed: () {
            if (bid.tasker != null) {
              Get.toNamed(
                Routes.CHAT_ROOM,
                arguments: {'taskId': bid.task, 'otherUser': bid.tasker},
              );
            }
          },
          text: 'Chat with Tasker',
          icon: Icons.chat_bubble_outline,
          height: 48,
          borderRadius: 30,
          foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
          borderColor: isDark ? Colors.grey[600] : Colors.grey[300],
        ),
        const SizedBox(height: 12),
        // Reject bid
        TextButton(
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: const Text('Reject Bid'),
                content: const Text(
                  'Are you sure you want to reject this bid? The tasker will be notified.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // close dialog
                      controller.rejectBid(bid.id);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                ],
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: Text(
            'Reject Bid',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, bool isDark, bool isBackground) {
    // Simplified status color logic
    if (status == 'ACTIVE') {
      return isBackground
          ? (isDark ? const Color(0xFF3D421B) : const Color(0xFFEEFCC2))
          : (isDark ? const Color(0xFFD6F089) : const Color(0xFF3B5204));
    }
    return Colors.grey;
  }

  Color _getStatusIndicatorColor(String status) {
    if (status == 'ACTIVE') return Colors.green;
    if (status == 'ACCEPTED') return Colors.blue;
    if (status == 'REJECTED') return Colors.red;
    return Colors.grey;
  }
}
