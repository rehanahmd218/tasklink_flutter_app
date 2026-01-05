import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/post_task_controller.dart';

class PostTaskCategorySelector extends StatelessWidget {
  final PostTaskController controller;

  const PostTaskCategorySelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryItem('Cleaning', Icons.cleaning_services, isDark),
              const SizedBox(width: 12),
              _buildCategoryItem('Delivery', Icons.local_shipping, isDark),
              const SizedBox(width: 12),
              _buildCategoryItem('Repair', Icons.handyman, isDark),
              const SizedBox(width: 12),
              _buildCategoryItem('Garden', Icons.yard, isDark),
              const SizedBox(width: 12),
              _buildCategoryItem('More', Icons.more_horiz, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == label;
      return GestureDetector(
        onTap: () => controller.setCategory(label),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isSelected ? TColors.primary.withValues(alpha: 0.2) : (isDark ? const Color(0xFF27272A) : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? TColors.primary : (isDark ? Colors.grey[700]! : Colors.grey[200]!), width: isSelected ? 2 : 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: isSelected ? Colors.yellow[800] : (isDark ? Colors.grey[400] : Colors.grey[600])),
               const SizedBox(height: 4),
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
            ],
          ),
        ),
      );
    });
  }
}
