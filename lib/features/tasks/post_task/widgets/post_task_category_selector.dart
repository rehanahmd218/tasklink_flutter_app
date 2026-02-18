import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/utils/constants/task_categories.dart';

class PostTaskCategorySelector extends StatelessWidget {
  final PostTaskController controller;

  const PostTaskCategorySelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final entry in TaskCategories.all) ...[
                _buildCategoryItem(entry, isDark),
                const SizedBox(width: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(TaskCategoryEntry entry, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == entry.id;
      return GestureDetector(
        onTap: () => controller.setCategory(entry.id),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isSelected
                ? TColors.primary.withValues(alpha: 0.2)
                : (isDark ? const Color(0xFF27272A) : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? TColors.primary
                  : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                entry.icon,
                size: 28,
                color: isSelected
                    ? Colors.yellow[800]
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                entry.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }
}
