import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisputeStatusTaskCard extends StatelessWidget {
  final String taskTitle;

  const DisputeStatusTaskCard({super.key, this.taskTitle = 'Task'});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('RELATED TASK',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : const Color(0xFF1c1c0d).withValues(alpha: 0.6),
                    letterSpacing: 0.5))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2c2b14) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                ),
                child: Icon(Icons.task_alt, color: Colors.grey[600], size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  taskTitle,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1c1c0d)),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
