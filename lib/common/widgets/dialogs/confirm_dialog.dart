import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../buttons/app_button.dart';

/// Confirmation dialog widget
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool isDanger;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.isDanger = false,
  });

  static Future<bool?> show({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? iconColor,
    bool isDanger = false,
  }) {
    return Get.dialog<bool>(
      ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        isDanger: isDanger,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor = iconColor ?? (isDanger ? TColors.error : TColors.primary);

    return Dialog(
      backgroundColor: isDark ? TColors.darkContainer : TColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: effectiveIconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: effectiveIconColor, size: 32),
              ),
            if (icon != null) const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.white : TColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: TColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: cancelText,
                    type: ButtonType.secondary,
                    onPressed: onCancel ?? () => Get.back(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: confirmText,
                    type: isDanger ? ButtonType.danger : ButtonType.primary,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}






