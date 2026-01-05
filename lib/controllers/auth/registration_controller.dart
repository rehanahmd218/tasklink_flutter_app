import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  
  void togglePasswordVisibility() => hidePassword.value = !hidePassword.value;
  void toggleConfirmPasswordVisibility() => hideConfirmPassword.value = !hideConfirmPassword.value;
}
