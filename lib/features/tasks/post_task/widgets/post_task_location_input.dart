import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/features/tasks/post_task/widgets/map_location_picker.dart';

class PostTaskLocationInput extends StatelessWidget {
  final PostTaskController controller;

  const PostTaskLocationInput({super.key, required this.controller});

  void _openMapPicker(BuildContext context) {
    Get.to(
      () => MapLocationPicker(controller: controller),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final hasLocation =
              controller.latitude.value != 0.0 &&
              controller.longitude.value != 0.0;
          final locationText = controller.selectedLocationName.value.isEmpty
              ? 'Tap to select location on map'
              : controller.selectedLocationName.value;

          return GestureDetector(
            onTap: () => _openMapPicker(context),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF27272A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasLocation
                      ? TColors.primary
                      : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
                  width: hasLocation ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: hasLocation
                                ? TColors.primary.withOpacity(0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            hasLocation
                                ? Icons.location_on
                                : Icons.add_location,
                            color: hasLocation
                                ? TColors.primary
                                : Colors.grey[600],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hasLocation
                                    ? 'Selected Location'
                                    : 'Select Location',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                locationText,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (hasLocation) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${controller.latitude.value.toStringAsFixed(4)}, ${controller.longitude.value.toStringAsFixed(4)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                  if (hasLocation)
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? Colors.grey[800]!
                                : Colors.grey[200]!,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: Colors.grey[300],
                      ),
                      child: Stack(
                        children: [
                          // Map preview placeholder
                          Center(
                            child: Icon(
                              Icons.map,
                              size: 48,
                              color: Colors.grey[500],
                            ),
                          ),
                          // Location marker
                          Center(
                            child: Icon(
                              Icons.location_on,
                              color: TColors.primary,
                              size: 40,
                            ),
                          ),
                          // Tap to edit overlay
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _openMapPicker(context),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Tap to edit',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
