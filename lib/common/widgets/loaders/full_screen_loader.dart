import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/constants/colors.dart';

// / Full screen loader with Lottie animation
// / Non-dismissible, used for important operations
class FullScreenLoader {
  static bool _isLoaderVisible = false;

  /// Show full screen loader.
  /// Closes any existing loader first so we never stack two.
  static void show({String text = 'Loading...', String? animation}) {
    _isLoaderVisible = true;
    Get.dialog(
      PopScope(
        canPop: false,
        child: _FullScreenLoaderWidget(
          text: text,
          animation: animation ?? TAnimations.docerAnimation,
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide the current loader.
  /// Uses an internal flag instead of Get.isDialogOpen because GetX's dialog
  /// tracking can desync after Get.offAllNamed() rebuilds the navigation stack.
  static void hide() {
    if (_isLoaderVisible) {
      Navigator.of(Get.overlayContext!).pop();
      _isLoaderVisible = false;
    }
  }
}

/// Internal widget for full screen loader
class _FullScreenLoaderWidget extends StatelessWidget {
  final String text;
  final String animation;

  const _FullScreenLoaderWidget({required this.text, required this.animation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Full screen Lottie Animation
          Lottie.asset(
            animation,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Loading Text
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? TColors.white : TColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
