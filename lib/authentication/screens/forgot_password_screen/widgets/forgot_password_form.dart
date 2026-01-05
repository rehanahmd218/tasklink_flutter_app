import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/controllers/auth/forgot_password_controller.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';
import '../../reset_password_screen/reset_password_screen.dart';

class ForgotPasswordForm extends StatelessWidget {
  final ForgotPasswordController controller;

  const ForgotPasswordForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Email or Phone Number',
          hint: 'Enter Email ID / Phone No.',
          controller: controller.email,
          prefixIcon: Icons.mail_outline,
        ),
        
        const SizedBox(height: 24),
        
        PrimaryButton(
          onPressed: () {
             Get.to(() => const ResetPasswordScreen());
          },
          text: 'Send Reset Code',
        ),
      ],
    );
  }
}
