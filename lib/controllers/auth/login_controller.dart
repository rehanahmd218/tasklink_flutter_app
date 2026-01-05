import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../navigation_menu.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Variables
  final isEmailLogin = true.obs; // false = Phone, true = Email
  final hidePassword = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final countryCode = '+1'.obs;

  void toggleLoginMethod() {
    isEmailLogin.value = !isEmailLogin.value;
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void login() {
    Get.offAll(() => const NavigationMenu());
  }
}
