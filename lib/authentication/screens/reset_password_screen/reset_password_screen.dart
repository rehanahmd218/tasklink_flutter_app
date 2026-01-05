import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/auth/reset_password_controller.dart';
import 'widgets/reset_otp_section.dart';
import 'widgets/reset_password_form.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : TColors.textPrimary)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Reset Password',
                style: GoogleFonts.inter(
                  fontSize: 30, // text-3xl
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.darkTextPrimary : TColors.textPrimary,
                  letterSpacing: -0.025,
                ),
              ),
              const SizedBox(height: 12),
              
              Text.rich(
                TextSpan(
                  text: 'Enter the 6-digit code sent to ',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: isDark ? TColors.darkTextSecondary : TColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'user@example.com',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[200] : Colors.black,
                      ),
                    ),
                    const TextSpan(text: ' and set your new password.'),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // OTP Section
              ResetOtpSection(controller: controller),
              
              const SizedBox(height: 32),
              
              // New Password Inputs
              ResetPasswordForm(controller: controller),
              
              const SizedBox(height: 32),
              
              // Support Link
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Having trouble? ',
                    style: GoogleFonts.inter(fontSize: 14, color: isDark ? TColors.darkTextSecondary : TColors.textSecondary),
                    children: [
                      TextSpan(
                        text: 'Contact Support',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                          decoration: TextDecoration.underline,
                          decorationColor: TColors.primary,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
