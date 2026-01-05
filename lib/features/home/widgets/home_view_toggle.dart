import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/home_controller.dart';

class HomeViewToggle extends StatelessWidget {
  const HomeViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.toggleViewMode(true),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: controller.isMapView.value ? TColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: controller.isMapView.value ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 18, color: controller.isMapView.value ? Colors.black : TColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Map',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: controller.isMapView.value ? Colors.black : TColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.toggleViewMode(false),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: !controller.isMapView.value ? Colors.white : Colors.transparent, 
                   borderRadius: BorderRadius.circular(8),
                   boxShadow: !controller.isMapView.value ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] : [],
                ),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.format_list_bulleted, size: 18, color: !controller.isMapView.value ? Colors.black : TColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'List',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: !controller.isMapView.value ? Colors.black : TColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
