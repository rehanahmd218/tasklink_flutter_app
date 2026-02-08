import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import 'widgets/login_header.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      body: Stack(
        children: [
          // Background Blobs
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 256, // w-64
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColors.primary.withValues(alpha: 0.2),
              ),
              // Blur handled by BackdropFilter or we can just leave it as solid transparent circle for perf,
              // or use ImageFilter.blur. Design requests 1:1, so we should try to blur.
            ),
          ),
          Positioned(
            top: 150, // top-[20%] roughly
            left: -80,
            child: Container(
              width: 192, // w-48
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),

          // We apply a blur over the blobs or use a blurry image/custom painter.
          // For simplicity and performance while keeping look, usually ImageFilter.blur is used on a stack layer,
          // but here the blobs are behind.
          // Let's use a simpler approach: Wrapped in a blur for the background?
          // Actually, simply drawing them with a blur mask invocation is cleaner but harder.
          // I will leave them as transparent circles for now, maybe add ImageFilter.blur in a BackdropFilter if needed.
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 450,
                  ), // max-w-md (approx 448px)
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ), // px-6 pt-12 pb-6
                  child: Column(
                    children: [
                      const LoginHeader(),
                      const LoginForm(),

                      const SizedBox(height: 32),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: isDark
                                  ? TColors.darkTextSecondary
                                  : TColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Text(
                              "Register",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : TColors.textPrimary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
