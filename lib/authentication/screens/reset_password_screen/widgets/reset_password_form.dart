import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/auth/reset_password_controller.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';

class ResetPasswordForm extends StatelessWidget {
  final ResetPasswordController controller;

  const ResetPasswordForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(ResetPasswordController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // New Password Inputs
        



         AppTextField(
          label: 'New Password' ,
          hint: 'At least 8 characters',
          controller: controller.newPassword,
          // helper text is not directly supported in AppTextField signature I saw, but maybe hint is enough?
          // placeholder was 'At least 8 characters'.
          // AppTextField has obscureText and toggle.
          obscureText: true,
          showPasswordToggle: true,
          prefixIcon: Icons.lock_outline,
        ),
        
         // Strength Indicator
        const SizedBox(height: 8),
        Obx(() => Row(
          children: List.generate(4, (index) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= controller.strength.value ? Colors.green : (isDark ? Colors.grey[700] : Colors.grey[200]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )),
        )),
        const SizedBox(height: 4),
        Obx(() => Text(
          controller.strength.value > 1 ? 'Medium strength' : 'Weak strength',
          style: GoogleFonts.inter(fontSize: 12, color: controller.strength.value > 1 ? Colors.green : Colors.red),
        )),
        
        const SizedBox(height: 20),
        
         AppTextField(
          label: 'Confirm New Password',
          hint: 'Re-enter password',
          controller: controller.confirmPassword,
          obscureText: true,
          showPasswordToggle: true,
          prefixIcon: Icons.lock_reset,
        ),
        
        const SizedBox(height: 40),
        
        // Button
        PrimaryButton(
          onPressed: () {},
          text: 'Reset Password',
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }
}
