import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tasklink/models/tasks/task_media_model.dart';
import '../../../../utils/constants/colors.dart';

class TaskCategoryIcon extends StatelessWidget {
  final String category;
  final bool isDark;
  final List<TaskMediaModel> media;
  const TaskCategoryIcon({
    super.key,
    required this.category,
    required this.isDark,
    this.media = const [],
  });

  @override
  Widget build(BuildContext context) {
    final categoryData = _getCategoryData(category);
    final color = categoryData['color'] as Color;
    final icon = categoryData['icon'] as IconData;
    final imageUrl = media.isNotEmpty ? media.first.file : null;
    if (imageUrl != null) {
      // Show task image if available
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Show category icon with color if no image
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDark
              ? color.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.1),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isDark ? color.withValues(alpha: 0.8) : color,
            size: 32,
          ),
        ),
      );
    }
  }
}

Map<String, dynamic> _getCategoryData(String category) {
  // Normalize category string
  final cat = category.toUpperCase();

  // Default
  Color color = TColors.primary;
  IconData icon = Icons.work_outline;

  if (cat.contains('CLEAN')) {
    color = Colors.blue;
    icon = Icons.cleaning_services_outlined;
  } else if (cat.contains('MOVING') || cat.contains('DELIVERY')) {
    color = Colors.orange;
    icon = Icons.local_shipping_outlined;
  } else if (cat.contains('GARDEN') || cat.contains('LAWN')) {
    color = Colors.green;
    icon = Icons.yard_outlined;
  } else if (cat.contains('FIX') ||
      cat.contains('REPAIR') ||
      cat.contains('PLUMB') ||
      cat.contains('ELECTRIC')) {
    color = Colors.red;
    icon = Icons.build_outlined;
  } else if (cat.contains('TECH') || cat.contains('COMPUTER')) {
    color = Colors.purple;
    icon = Icons.computer_outlined;
  } else if (cat.contains('PET')) {
    color = Colors.brown;
    icon = Icons.pets_outlined;
  }

  return {'color': color, 'icon': icon};
}
