import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/icons/task_category_icon.dart';
import 'package:tasklink/utils/helpers/distance_utils.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeTaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const HomeTaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        backgroundColor: isDark ? const Color(0xFF292524) : Colors.white,
        radius: 16,
        borderColor: Colors.transparent,
        showBorder: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Box
            TaskCategoryIcon(
              category: task.category,
              isDark: isDark,
              media: task.media,
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      RoundedContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        backgroundColor: TColors.primary,
                        radius: 20,
                        child: Text(
                          'Rs ${task.budget.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    task.addressText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: TColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    task.category,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.near_me, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        DistanceUtils.formatDistance(task.distance),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                      Spacer(),

                      // const SizedBox(width: 8),
                      // Container(
                      //   width: 4,
                      //   height: 4,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[300],
                      //     shape: BoxShape.circle,
                      //   ),
                      // ),
                      // const SizedBox(width: 8),
                      _buildTimeWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeWidget() {
    if (task.expiresAt != null) {
      final now = DateTime.now();
      final difference = task.expiresAt!.difference(now);

      if (difference.isNegative) {
        return Row(
          children: [
            const Icon(Icons.timer_off_outlined, size: 14, color: Colors.red),
            const SizedBox(width: 4),
            Text(
              'Expired',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        );
      }

      // If expiring soon (e.g., within 24 hours) show red
      final isExpiringSoon = difference.inHours < 24;

      return Row(
        children: [
          Icon(
            Icons.timer_outlined,
            size: 14,
            color: isExpiringSoon ? Colors.red : Colors.grey[400],
          ),
          const SizedBox(width: 4),
          Text(
            'Expires in ${difference.inHours}h',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isExpiringSoon ? Colors.red : Colors.grey[400],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.schedule, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 4),
          Text(
            timeago.format(task.createdAt),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ],
      );
    }
  }
}
