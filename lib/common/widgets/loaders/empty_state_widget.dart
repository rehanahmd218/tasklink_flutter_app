import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.lightContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TColors.borderPrimary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: TColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: TColors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.darkTextPrimary : TColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: TColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                PrimaryButton(onPressed: onAction!, text: actionLabel!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
