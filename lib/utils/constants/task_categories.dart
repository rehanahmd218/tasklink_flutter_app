import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Single source of truth for task categories. Matches backend Api/tasks/models.py CATEGORY_CHOICES.
class TaskCategoryEntry {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const TaskCategoryEntry({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// All task categories with icons and colors. Use [TaskCategories.byId] for lookup.
class TaskCategories {
  TaskCategories._();

  static const List<TaskCategoryEntry> all = [
    TaskCategoryEntry(id: 'CLEANING', label: 'Cleaning', icon: Icons.cleaning_services_outlined, color: Colors.blue),
    TaskCategoryEntry(id: 'DELIVERY', label: 'Delivery', icon: Icons.local_shipping_outlined, color: Colors.cyan),
    TaskCategoryEntry(id: 'HANDYMAN', label: 'Handyman', icon: Icons.handyman_outlined, color: Colors.brown),
    TaskCategoryEntry(id: 'MOVING', label: 'Moving', icon: Icons.local_shipping_outlined, color: Colors.amber),
    TaskCategoryEntry(id: 'ASSEMBLY', label: 'Assembly', icon: Icons.build_outlined, color: Colors.orange),
    TaskCategoryEntry(id: 'GARDENING', label: 'Gardening', icon: Icons.yard_outlined, color: Colors.green),
    TaskCategoryEntry(id: 'PAINTING', label: 'Painting', icon: Icons.format_paint_outlined, color: Colors.purple),
    TaskCategoryEntry(id: 'PLUMBING', label: 'Plumbing', icon: Icons.plumbing_outlined, color: Colors.indigo),
    TaskCategoryEntry(id: 'ELECTRICAL', label: 'Electrical', icon: Icons.electrical_services_outlined, color: Colors.orange),
    TaskCategoryEntry(id: 'OTHER', label: 'Other', icon: Icons.task_alt, color: Colors.grey),
  ];

  static final Map<String, TaskCategoryEntry> _byId = {
    for (final e in all) e.id: e,
  };

  /// Lookup by backend id (e.g. CLEANING, DELIVERY). Normalizes to uppercase.
  static TaskCategoryEntry? byId(String category) {
    if (category.isEmpty) return null;
    return _byId[category.toUpperCase()];
  }

  /// Icon for category; fallback to [Icons.task_alt] if unknown.
  static IconData getIcon(String category) => byId(category)?.icon ?? Icons.task_alt;

  /// Color for category; fallback to [TColors.primary] if unknown.
  static Color getColor(String category) => byId(category)?.color ?? TColors.primary;

  /// Display label for category; fallback to capitalized raw value if unknown.
  static String getLabel(String category) {
    final e = byId(category);
    if (e != null) return e.label;
    if (category.isEmpty) return 'Other';
    return category.length > 1
        ? '${category[0].toUpperCase()}${category.substring(1).toLowerCase()}'
        : category.toUpperCase();
  }

  /// List of category ids for API/filters (e.g. post task, filters).
  static List<String> get ids => all.map((e) => e.id).toList();
}
