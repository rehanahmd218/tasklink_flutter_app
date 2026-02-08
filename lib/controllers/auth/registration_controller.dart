import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/authentication/models/auth_response_model.dart';

import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader_with_button.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/services/authentication/auth_service.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

class RegistrationController extends GetxController {
  // Form controllers
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Password visibility toggles
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  // Loading state
  final isLoading = false.obs;

  // Auth service
  final AuthService _authService = AuthService();

  // Stored user after successful registration
  // Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  void togglePasswordVisibility() => hidePassword.value = !hidePassword.value;
  void toggleConfirmPasswordVisibility() =>
      hideConfirmPassword.value = !hideConfirmPassword.value;

  /// Register user with form data
  Future<void> register() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      FullScreenLoader.show(text: 'Creating your account...');
      isLoading.value = true;

      final AuthResponseModel response = await _authService.register(
        phoneNumber: phone.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), ''),
        email: email.text.trim(),
        password: password.text,
        passwordConfirm: confirmPassword.text,
        fullName: fullName.text.trim(),
        role: 'POSTER',
      );

      UserController.instance.setUser(response.user);

      FullScreenLoader.hide();

      FullScreenLoaderWithButton.show(
        text: 'Registration Successful!\nPlease verify your email to continue.',
        buttonText: 'Continue',
        onButtonPressed: () {
          FullScreenLoaderWithButton.hide();
          Get.offNamed(
            Routes.VERIFICATION,
            arguments: {
              'type': 'phone',
              'target': phone.text.trim().replaceAll(RegExp(r'[\s\-\(\)]'), ''),
            },
          );
        },
      );
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;

      // Use global error handler
      ErrorHandler.showErrorPopup(e, buttonText: 'Try Again');
    }
  }

  @override
  void onClose() {
    fullName.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
