import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final email = TextEditingController();

  void sendResetCode() {
    // Navigate to Reset Password Screen (OTP)
    // Get.to(() => const ResetPasswordScreen());
  }
}
