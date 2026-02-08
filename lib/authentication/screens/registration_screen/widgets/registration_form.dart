import 'package:flutter/material.dart';
import 'package:tasklink/controllers/auth/registration_controller.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';
import 'package:tasklink/utils/validators/form_validators.dart';

class RegistrationForm extends StatelessWidget {
  final RegistrationController controller;

  const RegistrationForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          AppTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: controller.fullName,
            validator: FormValidators.validateFullName,
          ),
          const SizedBox(height: 20),

          AppTextField(
            label: 'Phone Number',
            hint: '923001234567',
            controller: controller.phone,
            prefixIcon: Icons.call,
            keyboardType: TextInputType.phone,
            validator: FormValidators.validatePhone,
          ),
          const SizedBox(height: 20),

          AppTextField(
            label: 'Email Address',
            hint: 'you@example.com',
            controller: controller.email,
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
          ),
          const SizedBox(height: 20),

          AppTextField(
            label: 'Password',
            hint: 'Create a password (min 8 characters)',
            controller: controller.password,
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            showPasswordToggle: true,
            validator: FormValidators.validatePassword,
          ),
          const SizedBox(height: 20),

          AppTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: controller.confirmPassword,
            prefixIcon: Icons.lock_reset,
            obscureText: true,
            showPasswordToggle: true,
            validator: (value) => FormValidators.validateConfirmPassword(
              value,
              controller.password.text,
            ),
          ),
        ],
      ),
    );
  }
}
