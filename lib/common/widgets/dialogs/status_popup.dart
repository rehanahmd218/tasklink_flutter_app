import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/buttons/app_button.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Type of status popup
enum PopupType { success, error, info, warning }

/// Unified status popup dialog for success, error, info, and warning messages
class StatusPopup extends StatelessWidget {
  final PopupType type;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const StatusPopup({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  /// Show success popup
  static Future<void> showSuccess({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      type: PopupType.success,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Show error popup
  static Future<void> showError({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      type: PopupType.error,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Show info popup
  static Future<void> showInfo({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      type: PopupType.info,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Show warning popup
  static Future<void> showWarning({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return show(
      type: PopupType.warning,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Main show method
  static Future<void> show({
    required PopupType type,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
    bool dismissible = true,
  }) {
    return Get.dialog(
      PopScope(
        canPop: dismissible,
        child: StatusPopup(
          type: type,
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        ),
      ),
      barrierDismissible: dismissible,
    );
  }

  /// Get configuration for popup type
  _PopupConfig get _config {
    switch (type) {
      case PopupType.success:
        return _PopupConfig(
          icon: Icons.check_circle,
          color: TColors.success,
          defaultButtonText: 'Done',
        );
      case PopupType.error:
        return _PopupConfig(
          icon: Icons.error_outline,
          color: TColors.error,
          defaultButtonText: 'Try Again',
        );
      case PopupType.info:
        return _PopupConfig(
          icon: Icons.info_outline,
          color: TColors.info,
          defaultButtonText: 'Got It',
        );
      case PopupType.warning:
        return _PopupConfig(
          icon: Icons.warning_amber_rounded,
          color: TColors.warning,
          defaultButtonText: 'OK',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _config;

    return Dialog(
      backgroundColor: isDark ? TColors.darkContainer : TColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: config.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, color: config.color, size: 48),
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
              text: buttonText ?? config.defaultButtonText,
              type: type == PopupType.error
                  ? ButtonType.danger
                  : ButtonType.primary,
              onPressed: onPressed ?? () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal configuration class for popup types
class _PopupConfig {
  final IconData icon;
  final Color color;
  final String defaultButtonText;

  const _PopupConfig({
    required this.icon,
    required this.color,
    required this.defaultButtonText,
  });
}
