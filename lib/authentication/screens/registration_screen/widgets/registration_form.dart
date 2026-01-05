import 'package:flutter/material.dart';
import 'package:tasklink/controllers/auth/registration_controller.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';

class RegistrationForm extends StatelessWidget {
  final RegistrationController controller;

  const RegistrationForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Full Name',
          hint: 'Enter your full name',
          controller: controller.fullName,
        ),
        const SizedBox(height: 20),
        
        AppTextField(
          label: 'Phone Number', 
          hint: '+1 (555) 000-0000', 
          controller: controller.phone, 
          prefixIcon: Icons.call,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        
        AppTextField(
          label: 'Email Address', 
          hint: 'you@example.com', 
          controller: controller.email, 
          prefixIcon: Icons.mail_outline, 
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        
        AppTextField(
          label: 'Password',
          hint: 'Create a password',
          controller: controller.password,
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          showPasswordToggle: true,
        ),
        const SizedBox(height: 20),
        
        AppTextField(
          label: 'Confirm Password',
          hint: 'Confirm password',
          controller: controller.confirmPassword,
          prefixIcon: Icons.lock_reset,
          obscureText: true,
          showPasswordToggle: true,
        ),
      ],
    );
  }
}
