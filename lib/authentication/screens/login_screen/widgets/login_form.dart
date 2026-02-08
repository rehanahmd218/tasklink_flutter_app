import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/auth/login_controller.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/utils/validators/form_validators.dart';

import '../../../../utils/constants/colors.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle Group
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark
                  ? TColors.black.withValues(alpha: 0.6)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? TColors.darkBorderPrimary
                    : TColors.borderSecondary,
              ),
            ),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.isEmailLogin.value) {
                          controller.toggleLoginMethod();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !controller.isEmailLogin.value
                              ? (isDark ? TColors.darkContainer : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: !controller.isEmailLogin.value
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            'Phone Number',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: !controller.isEmailLogin.value
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: !controller.isEmailLogin.value
                                  ? (isDark
                                        ? Colors.white
                                        : TColors.textPrimary)
                                  : (isDark
                                        ? TColors.darkTextSecondary
                                        : TColors.textSecondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!controller.isEmailLogin.value) {
                          controller.toggleLoginMethod();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: controller.isEmailLogin.value
                              ? (isDark ? TColors.darkContainer : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: controller.isEmailLogin.value
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            'Email',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: controller.isEmailLogin.value
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: controller.isEmailLogin.value
                                  ? (isDark
                                        ? Colors.white
                                        : TColors.textPrimary)
                                  : (isDark
                                        ? TColors.darkTextSecondary
                                        : TColors.textSecondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Email or Phone Input
          Obx(
            () => controller.isEmailLogin.value
                ? _buildEmailInput(isDark, controller)
                : _buildPhoneInput(isDark, controller),
          ),

          const SizedBox(height: 8),

          // Password
          AppTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: controller.password,
            obscureText: true,
            showPasswordToggle: true,
            validator: FormValidators.validatePassword,
          ),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.toNamed(Routes.FORGOT_PASSWORD);
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? TColors.darkTextSecondary
                      : TColors.textSecondary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Login Button
          Obx(
            () => PrimaryButton(
              onPressed: controller.isLoading.value ? () {} : controller.login,
              text: controller.isLoading.value ? 'Logging in...' : 'Log In',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInput(bool isDark, LoginController controller) {
    return AppTextField(
      label: 'Email Address',
      hint: 'name@example.com',
      prefixIcon: Icons.mail_outline,
      controller: controller.email,
      keyboardType: TextInputType.emailAddress,
      validator: FormValidators.validateEmail,
    );
  }

  Widget _buildPhoneInput(bool isDark, LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? TColors.darkTextPrimary : TColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? TColors.darkContainer : TColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? TColors.darkBorderPrimary
                      : TColors.borderSecondary,
                ),
              ),
              child: Center(
                child: Text(
                  '🇵🇰 +92',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? TColors.darkTextPrimary
                        : TColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                hint: '3001234567',
                keyboardType: TextInputType.phone,
                controller: controller.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
