import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Type of snackbar
enum SnackbarType {
  success,
  error,
  info,
  warning,
}

/// Unified status snackbar for success, error, info, and warning messages
class StatusSnackbar {
  /// Show success snackbar
  static void showSuccess({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      type: SnackbarType.success,
      message: message,
      duration: duration,
    );
  }

  /// Show error snackbar
  static void showError({
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      type: SnackbarType.error,
      message: message,
      duration: duration,
    );
  }

  /// Show info snackbar
  static void showInfo({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      type: SnackbarType.info,
      message: message,
      duration: duration,
    );
  }

  /// Show warning snackbar
  static void showWarning({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      type: SnackbarType.warning,
      message: message,
      duration: duration,
    );
  }

  /// Main show method
  static void show({
    required SnackbarType type,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final config = _getConfig(type);
    final isDark = Get.isDarkMode;

    Get.snackbar(
      '', // Empty title since we're using a custom message widget
      '',
      titleText: const SizedBox.shrink(), // Hide default title
      messageText: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: config.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              config.icon,
              color: config.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Message
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? TColors.white : TColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? TColors.darkContainer : TColors.white,
      borderRadius: 12,
      borderColor: config.color.withValues(alpha: 0.3),
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.BOTTOM,
      showProgressIndicator: false,
    );
  }

  /// Get configuration for snackbar type
  static _SnackbarConfig _getConfig(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarConfig(
          icon: Icons.check_circle,
          color: TColors.success,
        );
      case SnackbarType.error:
        return _SnackbarConfig(
          icon: Icons.error,
          color: TColors.error,
        );
      case SnackbarType.info:
        return _SnackbarConfig(
          icon: Icons.info,
          color: TColors.info,
        );
      case SnackbarType.warning:
        return _SnackbarConfig(
          icon: Icons.warning_amber_rounded,
          color: TColors.warning,
        );
    }
  }
}

/// Internal configuration class for snackbar types
class _SnackbarConfig {
  final IconData icon;
  final Color color;

  const _SnackbarConfig({
    required this.icon,
    required this.color,
  });
}
