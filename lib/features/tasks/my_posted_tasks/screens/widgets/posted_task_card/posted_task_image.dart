import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/utils/helpers/category_helper.dart';

class PostedTaskImage extends StatelessWidget {
  final TaskModel task;
  final bool isDark;

  const PostedTaskImage({
    super.key,
    required this.task,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = task.media.isNotEmpty ? task.media.first.file : null;
    final categoryColor = CategoryHelper.getCategoryColor(task.category);
    final categoryIcon = CategoryHelper.getCategoryIcon(task.category);

    if (imageUrl != null) {
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
    }
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDark
            ? categoryColor.withValues(alpha: 0.2)
            : categoryColor.withValues(alpha: 0.1),
      ),
      child: Center(
        child: Icon(
          categoryIcon,
          color: isDark
              ? categoryColor.withValues(alpha: 0.8)
              : categoryColor,
          size: 32,
        ),
      ),
    );
  }
}
