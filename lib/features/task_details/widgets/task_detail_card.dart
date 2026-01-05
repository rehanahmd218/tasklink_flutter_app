import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class TaskDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final MaterialColor color;

  const TaskDetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? color[900]!.withValues(alpha: 0.3) : color[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isDark ? color[400] : color[600], size: 20),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: TColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
