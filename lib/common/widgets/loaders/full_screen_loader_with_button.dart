import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Full screen loader with Lottie animation, text, and action button
/// Used for operations that need user acknowledgment
class FullScreenLoaderWithButton {
  /// Show full screen loader with button
  static void show({
    String text = 'Operation Complete',
    String? animation,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
  }) {
    Get.dialog(
      PopScope(
        canPop: false, // Prevents back button
        child: _FullScreenLoaderWithButtonWidget(
          text: text,
          animation: animation ?? TAnimations.greenTickAnimation2,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
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

/// Internal widget for full screen loader with button
class _FullScreenLoaderWithButtonWidget extends StatelessWidget {
  final String text;
  final String animation;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const _FullScreenLoaderWithButtonWidget({
    required this.text,
    required this.animation,
    required this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              Lottie.asset(
                animation,
                width: 400,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.check_circle,
                    size: 200,
                    color: TColors.primary,
                  );
                },
              ),
              const SizedBox(height: 32),

              // Message Text
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? TColors.white : TColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(onPressed: onButtonPressed ?? FullScreenLoaderWithButton.hide, text: buttonText)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
