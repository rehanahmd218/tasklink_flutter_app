import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const SettingsCard({
    super.key,
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2e2d15) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.transparent : Colors.grey[100]!),
        boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Column(children: children),
    );
  }
}
