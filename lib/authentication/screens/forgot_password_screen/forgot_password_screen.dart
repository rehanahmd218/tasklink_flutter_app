import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/auth/forgot_password_controller.dart';
// Will implement next
import 'widgets/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Forgot Password',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Hero Illustration
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: TColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.lock_reset, size: 48, color: Colors.amber), // yellow-600
              ),
            ),
            const SizedBox(height: 24),
            
            // Headline
            Text(
              'Forgot Password?',
              style: GoogleFonts.inter(
                fontSize: 30, // text-3xl
                fontWeight: FontWeight.bold,
                color: isDark ? TColors.darkTextPrimary : TColors.textPrimary,
                letterSpacing: -0.025,
              ),
            ),
            const SizedBox(height: 12),
            
            // Body Text
            Text(
              "Don't worry! It happens. Please enter the address associated with your account.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: isDark ? TColors.darkTextSecondary : TColors.textSecondary,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Input Form
            ForgotPasswordForm(controller: controller),
            
            const Spacer(),
            
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Remember password? ', style: GoogleFonts.inter(fontSize: 14, color: isDark ? TColors.darkTextSecondary : TColors.textSecondary)),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text('Log in', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber[700])), // yellow-600
                ),
              ],
            ),
            const SizedBox(height: 32),
             Container(
              height: 4,
              width: 100, // w-1/3 roughly
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
