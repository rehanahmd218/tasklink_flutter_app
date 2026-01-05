import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';

class TaskLocationCard extends StatelessWidget {
  final String location;

  const TaskLocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const color = Colors.green;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : Colors.grey[50], // bg-gray-50
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? color[900]!.withValues(alpha: 0.3) : color[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: isDark ? color[400] : color[600], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Location', style: TextStyle(color: TColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
