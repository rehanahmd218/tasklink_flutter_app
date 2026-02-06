






import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/constants/colors.dart';

// / Full screen loader with Lottie animation
// / Non-dismissible, used for important operations
class FullScreenLoader {
  /// Show full screen loader
  static void show({
    String text = 'Loading...',
    String? animation,
  }) {
    Get.dialog(
      PopScope(
        canPop: false, // Prevents back button
        child: _FullScreenLoaderWidget(
          text: text,
          animation: animation ?? TAnimations.docerAnimation,
        ),
      ),
      barrierDismissible: false, // Prevents tap outside to dismiss
    );
  }

  /// Hide the current loader
  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

/// Internal widget for full screen loader
class _FullScreenLoaderWidget extends StatelessWidget {
  final String text;
  final String animation;

  const _FullScreenLoaderWidget({
    required this.text,
    required this.animation,
  });

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
