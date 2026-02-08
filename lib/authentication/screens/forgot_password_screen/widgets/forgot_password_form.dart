import 'package:flutter/material.dart';
import 'package:tasklink/controllers/auth/forgot_password_controller.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';
import 'package:tasklink/utils/validators/form_validators.dart';

class ForgotPasswordForm extends StatelessWidget {
  final ForgotPasswordController controller;

  const ForgotPasswordForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Email or Phone Number',
            hint: 'Enter Email ID / Phone No.',
            controller: controller.email,
            prefixIcon: Icons.mail_outline,
            validator: (value) =>
                FormValidators.validateRequired(value, 'Email or Phone Number'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () => controller.sendResetCode(),
            text: 'Send Reset Code',
          ),
        ],
      ),
    );
  }
}
