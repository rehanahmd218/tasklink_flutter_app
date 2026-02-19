import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/app_card.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/routes/routes.dart';

/// Reusable card for a single "my bid" (tasker view). Used in BidsTaskerView and Tasker My Tasks > Bids.
class MyBidCard extends StatelessWidget {
  final BidModel bid;
  final VoidCallback? onViewTask;
  final VoidCallback? onEditBid;
  final VoidCallback? onDeleteBid;

  const MyBidCard({
    super.key,
    required this.bid,
    this.onViewTask,
    this.onEditBid,
    this.onDeleteBid,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.handyman_outlined,
                    size: 28,
                    color: isDark ? TColors.primary : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid.taskTitle ?? 'Unknown Task',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark
                            ? TColors.darkTextPrimary
                            : TColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Posted by Client',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark
                            ? TColors.darkTextSecondary
                            : TColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(bid.status, isDark),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: isDark
                      ? TColors.darkBorderPrimary
                      : TColors.borderSecondary,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR BID',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: TColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rs ${bid.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? TColors.darkTextPrimary
                            : TColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TASK BUDGET',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: TColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rs ${(bid.amount * 0.9).floor()} - Rs ${(bid.amount * 1.2).ceil()}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? TColors.darkTextSecondary
                            : TColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewTask ?? () {
                Get.toNamed(Routes.TASK_DETAILS, arguments: {'taskId': bid.task});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'View Task',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (onEditBid != null || onDeleteBid != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (onEditBid != null && bid.status.toUpperCase() == 'ACTIVE') ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEditBid,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Bid'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark
                            ? TColors.darkTextPrimary
                            : TColors.textSecondary,
                        side: BorderSide(
                          color: isDark
                              ? TColors.darkBorderPrimary
                              : TColors.borderSecondary,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (onDeleteBid != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDeleteBid,
                      icon: Icon(Icons.delete_outline, size: 18, color: TColors.error),
                      label: Text(
                        'Delete Bid',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: TColors.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TColors.error,
                        side: const BorderSide(color: TColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isDark) {
    Color textColor;
    Color bgColor;
    String label = status.toUpperCase();

    if (status.toUpperCase() == 'ACTIVE') {
      textColor = isDark
          ? TColors.darkTextSecondary
          : TColors.textSecondary;
      bgColor = isDark ? TColors.darkContainer : TColors.softGrey;
      label = 'PENDING';
    } else if (status.toUpperCase() == 'ACCEPTED') {
      textColor = TColors.success;
      bgColor = TColors.success.withValues(alpha: 0.1);
    } else if (status.toUpperCase() == 'REJECTED') {
      textColor = TColors.error;
      bgColor = TColors.error.withValues(alpha: 0.1);
    } else {
      textColor = TColors.error;
      bgColor = TColors.error.withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
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
