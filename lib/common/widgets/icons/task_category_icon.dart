import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tasklink/models/tasks/task_media_model.dart';
import 'package:tasklink/utils/constants/task_categories.dart';

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
    final color = TaskCategories.getColor(category);
    final icon = TaskCategories.getIcon(category);
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
