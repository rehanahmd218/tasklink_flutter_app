import 'package:flutter/material.dart';

/// Category Icon and Color Mapping
///
/// Maps task categories to their corresponding icons and colors

class CategoryHelper {
  /// Get icon for a category
  static IconData getCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();

    if (categoryLower.contains('moving') ||
        categoryLower.contains('furniture')) {
      return Icons.widgets_outlined;
    } else if (categoryLower.contains('clean')) {
      return Icons.cleaning_services_outlined;
    } else if (categoryLower.contains('garden') ||
        categoryLower.contains('lawn') ||
        categoryLower.contains('yard')) {
      return Icons.yard_outlined;
    } else if (categoryLower.contains('paint')) {
      return Icons.format_paint_outlined;
    } else if (categoryLower.contains('plumb')) {
      return Icons.plumbing_outlined;
    } else if (categoryLower.contains('electric')) {
      return Icons.electrical_services_outlined;
    } else if (categoryLower.contains('repair') ||
        categoryLower.contains('fix')) {
      return Icons.build_outlined;
    } else if (categoryLower.contains('delivery') ||
        categoryLower.contains('transport')) {
      return Icons.local_shipping_outlined;
    } else if (categoryLower.contains('pet')) {
      return Icons.pets_outlined;
    } else if (categoryLower.contains('cook') ||
        categoryLower.contains('food')) {
      return Icons.restaurant_outlined;
    } else if (categoryLower.contains('tutor') ||
        categoryLower.contains('teach')) {
      return Icons.school_outlined;
    } else if (categoryLower.contains('design') ||
        categoryLower.contains('graphic')) {
      return Icons.design_services_outlined;
    } else if (categoryLower.contains('photo')) {
      return Icons.camera_alt_outlined;
    } else if (categoryLower.contains('write') ||
        categoryLower.contains('content')) {
      return Icons.edit_outlined;
    } else if (categoryLower.contains('tech') ||
        categoryLower.contains('computer') ||
        categoryLower.contains('it')) {
      return Icons.computer_outlined;
    } else {
      return Icons.task_alt;
    }
  }

  /// Get color for a category
  static Color getCategoryColor(String category) {
    final categoryLower = category.toLowerCase();

    if (categoryLower.contains('moving') ||
        categoryLower.contains('furniture')) {
      return Colors.amber;
    } else if (categoryLower.contains('clean')) {
      return Colors.blue;
    } else if (categoryLower.contains('garden') ||
        categoryLower.contains('lawn') ||
        categoryLower.contains('yard')) {
      return Colors.green;
    } else if (categoryLower.contains('paint')) {
      return Colors.purple;
    } else if (categoryLower.contains('plumb')) {
      return Colors.indigo;
    } else if (categoryLower.contains('electric')) {
      return Colors.orange;
    } else if (categoryLower.contains('repair') ||
        categoryLower.contains('fix')) {
      return Colors.brown;
    } else if (categoryLower.contains('delivery') ||
        categoryLower.contains('transport')) {
      return Colors.cyan;
    } else if (categoryLower.contains('pet')) {
      return Colors.pink;
    } else if (categoryLower.contains('cook') ||
        categoryLower.contains('food')) {
      return Colors.red;
    } else if (categoryLower.contains('tutor') ||
        categoryLower.contains('teach')) {
      return Colors.deepPurple;
    } else if (categoryLower.contains('design') ||
        categoryLower.contains('graphic')) {
      return Colors.teal;
    } else if (categoryLower.contains('photo')) {
      return Colors.deepOrange;
    } else if (categoryLower.contains('write') ||
        categoryLower.contains('content')) {
      return Colors.blueGrey;
    } else if (categoryLower.contains('tech') ||
        categoryLower.contains('computer') ||
        categoryLower.contains('it')) {
      return Colors.lightBlue;
    } else {
      return Colors.grey;
    }
  }
}
