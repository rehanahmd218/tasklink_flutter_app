import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/loaders/loading_overlay.dart';
import 'package:tasklink/controllers/auth/verification_controller.dart';

import 'widgets/verification_keypad.dart';
import 'widgets/verification_otp_display.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : TColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          message: 'Verifying OTP...',
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          controller.type == VerificationType.EMAIL
                              ? 'Verify Email Address'
                              : 'Verify Phone Number',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? TColors.darkTextPrimary
                                : TColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text.rich(
                          TextSpan(
                            text: 'Enter the code we sent to \n',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: isDark
                                  ? TColors.darkTextSecondary
                                  : TColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: controller.target ?? '',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // OTP Display
                        VerificationOtpDisplay(controller: controller),

                        const SizedBox(height: 32),

                        // Timer
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 18,
                                  color: TColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Resend code in ',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: TColors.textSecondary,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    controller.timerText.value,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: TColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Obx(
                              () => TextButton(
                                onPressed: controller.isResendEnabled.value
                                    ? () => controller.sendOtp()
                                    : null,
                                child: Text(
                                  'Resend Code',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: controller.isResendEnabled.value
                                        ? (isDark
                                              ? Colors.white
                                              : TColors.textPrimary)
                                        : TColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Verify Button
                        Obx(
                          () => PrimaryButton(
                            onPressed: controller.isLoading.value
                                ? () {}
                                : () => controller.verifyOtp(),
                            text: controller.isLoading.value
                                ? 'Verifying...'
                                : 'Verify',
                            icon: Icons.check_circle_outline,
                            height: 48,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Custom Keypad
              VerificationKeypad(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
