import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final otpControllers = List.generate(6, (index) => TextEditingController());
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final hideNewPassword = true.obs;
  final hideConfirmPassword = true.obs;
  
  void toggleNewPasswordVisibility() => hideNewPassword.value = !hideNewPassword.value;
  void toggleConfirmPasswordVisibility() => hideConfirmPassword.value = !hideConfirmPassword.value;

  // Mock Strength
  final strength = 0.obs; // 0-4
  
  @override
  void onInit() {
    super.onInit();
    newPassword.addListener(() {
      updateStrength(newPassword.text);
    });
  }
  
  void updateStrength(String pass) {
    if (pass.isEmpty) {
      strength.value = 0;
    } else if (pass.length < 6) {
      strength.value = 1;
    } else if (pass.length < 8) {
      strength.value = 2;
    } else {
      strength.value = 3;
    }
  }
}
