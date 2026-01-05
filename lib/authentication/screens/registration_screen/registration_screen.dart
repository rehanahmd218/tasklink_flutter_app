import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/auth/registration_controller.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'widgets/registration_form.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Join TaskLink',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : TColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connect, collaborate, and get things done.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: isDark ? TColors.darkTextSecondary : TColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Form
              RegistrationForm(controller: controller),
              
              const SizedBox(height: 32),
              
              // Terms
              Text.rich(
                TextSpan(
                  text: 'By signing up, you agree to our ',
                  style: GoogleFonts.inter(fontSize: 12, color: isDark ? TColors.darkTextSecondary : TColors.textSecondary),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: GoogleFonts.inter(color: TColors.primary, fontWeight: FontWeight.bold), // Using primary (yellow) might be hard to read on light bg if it's too bright? Using design logic.
                      // HTML has text-primary.
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: GoogleFonts.inter(color: TColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Button
              PrimaryButton(
                onPressed: () {}, // TODO: connect to controller
                text: 'Create Account',
              ),
              
              const SizedBox(height: 24),
              
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.inter(fontSize: 14, color: isDark ? TColors.darkTextSecondary : TColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Log in',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
