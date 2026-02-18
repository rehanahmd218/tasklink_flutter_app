import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/task_categories.dart';

/// Category icon and color mapping. Delegates to [TaskCategories] (single source of truth).
class CategoryHelper {
  /// Get icon for a category (backend id e.g. CLEANING, DELIVERY).
  static IconData getCategoryIcon(String category) =>
      TaskCategories.getIcon(category);

  /// Get color for a category.
  static Color getCategoryColor(String category) =>
      TaskCategories.getColor(category);

  /// Get display label for a category.
  static String getCategoryLabel(String category) =>
      TaskCategories.getLabel(category);
}
