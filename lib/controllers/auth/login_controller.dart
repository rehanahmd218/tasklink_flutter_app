import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/authentication/models/auth_response_model.dart';
import 'package:tasklink/controllers/location/location_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';

import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/services/authentication/auth_service.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Toggle: false = Phone, true = Email
  final isEmailLogin = true.obs;
  final hidePassword = true.obs;

  // Text controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final countryCode = '+92'.obs;

  // Loading state
  final isLoading = false.obs;

  // Auth service
  final AuthService _authService = AuthService();

  void toggleLoginMethod() {
    isEmailLogin.value = !isEmailLogin.value;
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  /// Get the username (phone or email) based on toggle
  String get _username {
    if (isEmailLogin.value) {
      return email.text.trim();
    } else {
      // Format phone: remove spaces/dashes, prepend country code without +
      final cleanPhone = phone.text.trim().replaceAll(
        RegExp(r'[\s\-\(\)]'),
        '',
      );
      final code = countryCode.value.replaceAll('+', '');
      return '$code$cleanPhone';
    }
  }

  /// Login with form data
  Future<void> login() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      FullScreenLoader.show(text: 'Logging in...');
      isLoading.value = true;

      final AuthResponseModel response = await _authService.login(
        username: _username,
        password: password.text,
      );

      UserController.instance.setUser(response.user);

      FullScreenLoader.hide();

      // Show success snackbar
      StatusSnackbar.showSuccess(message: 'Successfully logged in!');

      // Navigate based on status
      UserController.instance.redirectBasedOnStatus();
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;

      // Use global error handler
      ErrorHandler.showErrorPopup(e, buttonText: 'Try Again');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      FullScreenLoader.show(text: 'Logging out...');

      await _authService.logout();
      await UserController.instance.clearUser();

      FullScreenLoader.hide();
      UserController.instance.redirectBasedOnStatus();
    } catch (e) {
      FullScreenLoader.hide();
      // Force logout on error
      await UserController.instance.clearUser();
      UserController.instance.redirectBasedOnStatus();
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    phone.dispose();
    super.onClose();
  }
}
