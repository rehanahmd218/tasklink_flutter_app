import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_button.dart';

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
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? iconColor,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        isDanger: isDanger,
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
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
                    onPressed: onCancel ?? () => Navigator.pop(context),
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

/// Success popup dialog
class SuccessPopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const SuccessPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Done',
    this.onPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Done',
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessPopup(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: TColors.success, size: 48),
            ),
            const SizedBox(height: 24),

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

            // Button
            AppButton(
              text: buttonText,
              onPressed: onPressed ?? () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error popup dialog
class ErrorPopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Try Again',
    this.onPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Try Again',
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorPopup(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            // Error icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: TColors.error, size: 48),
            ),
            const SizedBox(height: 24),

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

            // Button
            AppButton(
              text: buttonText,
              type: ButtonType.danger,
              onPressed: onPressed ?? () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Info popup dialog
class InfoPopup extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const InfoPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Got It',
    this.onPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Got It',
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoPopup(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            // Info icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TColors.info.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline, color: TColors.info, size: 48),
            ),
            const SizedBox(height: 24),

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

            // Button
            AppButton(
              text: buttonText,
              onPressed: onPressed ?? () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

