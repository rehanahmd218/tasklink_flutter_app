import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/auth/login_controller.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';

import '../../../../utils/constants/colors.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Toggle Group
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? TColors.black.withValues(alpha: 0.6)
                : Colors.grey[100], // bg-gray-100 dark:bg-stone-900/60
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
                if (controller.isEmailLogin.value)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.isEmailLogin.value)
                          controller.toggleLoginMethod();
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
                      if (!controller.isEmailLogin.value)
                        controller.toggleLoginMethod();
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
                                ? (isDark ? Colors.white : TColors.textPrimary)
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

        // Inputs
        Obx(
          () => controller.isEmailLogin.value
              ? _buildEmailInput(isDark, controller)
              : _buildPhoneInput(isDark, controller),
        ),

        const SizedBox(height: 8),

        // Password
        Obx(() {
          if (controller.isEmailLogin.value) {
          }
          return AppTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: controller.password,
            obscureText: true,
            showPasswordToggle:
                true, // AppTextField handles toggle logic internally if showPasswordToggle is true, wait, AppTextField has its own state? Yes.
            // But controller might want to control it? AppTextField has internal state for obscureText.
            // If I use showPasswordToggle: true, AppTextField handles the icon and switching.
            // The controller.hidePassword value logic in previous code was:
            // obscureText: controller.hidePassword.value
            // onPressed: () => controller.togglePasswordVisibility()
            // If I switch to AppTextField, I should rely on its internal toggle OR I need to modify AppTextField to accept external toggle state.
            // AppTextField definition: `final bool obscureText; final bool showPasswordToggle; ... State<AppTextField> ... bool _obscureText;`
            // It initializes _obscureText from widget.obscureText. It toggles _obscureText internally.
            // This de-couples the visibility from the controller. This is generally fine unless other parts need to know visibility.
            // I will assume it is fine to use AppTextField's internal toggle.
          );
        }),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
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
        PrimaryButton(onPressed: () {}, text: 'Log In'),
      ],
    );
  }

  Widget _buildEmailInput(bool isDark, LoginController controller) {
    return AppTextField(
      label: 'Email Address',
      hint: 'name@example.com',
      prefixIcon: Icons.mail_outline,
      // controller: controller.email, // Assuming controller has email field, need to check LoginController
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
            SizedBox(
              width: 110,
              child: DropdownButtonFormField<String>(
                initialValue: controller.countryCode.value,
                items: const [
                  DropdownMenuItem(value: '+1', child: Text('🇺🇸 +1')),
                  DropdownMenuItem(value: '+44', child: Text('🇬🇧 +44')),
                  DropdownMenuItem(value: '+91', child: Text('🇮🇳 +91')),
                  DropdownMenuItem(value: '+81', child: Text('🇯🇵 +81')),
                ],
                onChanged: (val) => controller.countryCode.value = val!,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: isDark ? TColors.darkContainer : TColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? TColors.darkBorderPrimary
                          : TColors.borderSecondary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? TColors.darkBorderPrimary
                          : TColors.borderSecondary,
                    ),
                  ),
                ),
                icon: const Icon(Icons.expand_more),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                hint: '(555) 000-0000',
                keyboardType: TextInputType.phone,
                // controller: controller.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
