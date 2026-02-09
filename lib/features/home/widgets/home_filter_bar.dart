import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../controllers/features/home_controller.dart';

class HomeFilterBar extends StatelessWidget {
  const HomeFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Distance Filter
          GestureDetector(
            onTap: () => _showRadiusModal(context, controller),
            child: Obx(() {
              final radius = controller.radius.value;
              final label = radius == 30 ? 'Any distance' : '${radius}km';
              final isActive = radius != 30; // Active if not default

              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: Chip(
                  label: Text(label),
                  avatar: Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: isActive
                        ? Colors.white
                        : (isDark ? Colors.grey[300] : Colors.grey[700]),
                  ),
                  backgroundColor: isActive
                      ? TColors.primary
                      : (isDark ? Colors.grey[800] : Colors.white),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? Colors.white
                        : (isDark ? Colors.grey[300] : Colors.grey[700]),
                  ),
                  side: isActive
                      ? BorderSide.none
                      : BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              );
            }),
          ),

          _buildFilterChip('All', Icons.apps, isActive: true, isDark: isDark),
          _buildFilterChip(
            'Moving',
            Icons.widgets_outlined,
            isDark: isDark,
          ), // box icon substitute
          _buildFilterChip(
            'Cleaning',
            Icons.cleaning_services_outlined,
            isDark: isDark,
          ),
          _buildFilterChip(
            'Gardening',
            Icons.yard_outlined,
            isDark: isDark,
          ), // potted_plant substitute
          _buildFilterChip('Assembly', Icons.build_outlined, isDark: isDark),
        ],
      ),
    );
  }

  void _showRadiusModal(BuildContext context, HomeController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Distance',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildRadiusOption(1, controller, isDark),
                _buildRadiusOption(5, controller, isDark),
                _buildRadiusOption(10, controller, isDark),
                _buildRadiusOption(20, controller, isDark),
                _buildRadiusOption(30, controller, isDark, label: 'Any (30km)'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusOption(
    int value,
    HomeController controller,
    bool isDark, {
    String? label,
  }) {
    return Obx(() {
      final isSelected = controller.radius.value == value;
      return FilterChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(label ?? '${value}km'),
        labelStyle: GoogleFonts.inter(
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.grey[300] : Colors.black87),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
        selectedColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
        onSelected: (bool selected) {
          if (selected) {
            controller.updateRadius(value);
            Get.back(); // Close modal on selection
          }
        },
      );
    });
  }

  Widget _buildFilterChip(
    String label,
    IconData icon, {
    bool isActive = false,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Chip(
        label: Text(label),
        avatar: Icon(
          icon,
          size: 18,
          color: isActive
              ? Colors.black
              : (isDark ? Colors.grey[300] : Colors.grey[700]),
        ),
        backgroundColor: isActive
            ? TColors.primary
            : (isDark ? Colors.grey[800] : Colors.white),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isActive
              ? Colors.black
              : (isDark ? Colors.grey[300] : Colors.grey[700]),
        ),
        side: isActive
            ? BorderSide.none
            : BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    );
  }
}
