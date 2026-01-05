import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusStepper extends StatelessWidget {
  const StatusStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? TColors.backgroundDark : TColors.backgroundLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Connecting Line
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStep(
                context: context,
                icon: Icons.check,
                label: 'Assigned',
                isActive: true, // Completed
                isCompleted: true,
              ),
              _buildStep(
                context: context,
                icon: Icons.sync,
                label: 'In Progress',
                isActive: true, // Active
                isCompleted: false,
                isCurrent: true,
              ),
              _buildStep(
                context: context,
                icon: Icons.flag,
                label: 'Completed',
                isActive: false,
                isCompleted: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isCompleted,
    bool isCurrent = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color circleColor;
    Color iconColor;
    Color borderColor;

    if (isCompleted) {
      circleColor = TColors.primary;
      iconColor = Colors.black;
      borderColor = TColors.primary;
    } else if (isCurrent) {
      circleColor = TColors.primary;
      iconColor = Colors.black;
      borderColor = TColors.primary; // Or ring logic
    } else {
      circleColor = isDark ? TColors.darkContainer : TColors.grey;
      iconColor = TColors.textSecondary;
      borderColor = isDark ? TColors.darkBorderPrimary : TColors.borderSecondary;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            boxShadow: isCurrent ? [
              BoxShadow(
                color: TColors.primary.withValues(alpha: 0.3),
                blurRadius: 0,
                spreadRadius: 4,
              )
            ] : null,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            color: isActive 
                ? (isDark ? TColors.white : TColors.textPrimary)
                : TColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

