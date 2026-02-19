import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/services/authentication/auth_service.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';

class ResetPasswordController extends GetxController {
  final otpControllers = List.generate(6, (index) => TextEditingController());
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final hideNewPassword = true.obs;
  final hideConfirmPassword = true.obs;

  // Mock Strength
  final strength = 0.obs;

  void toggleNewPasswordVisibility() =>
      hideNewPassword.value = !hideNewPassword.value;
  void toggleConfirmPasswordVisibility() =>
      hideConfirmPassword.value = !hideConfirmPassword.value;

  // Arguments
  final identifier = ''.obs;

  final AuthService _authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      identifier.value = args['identifier'] ?? '';
    }

    newPassword.addListener(() {
      updateStrength(newPassword.text);
    });
  }

  String get otpCode {
    return otpControllers.map((c) => c.text).join();
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    final otp = otpCode;
    if (otp.length < 6) {
      StatusSnackbar.showError(message: 'Please enter the 6-digit OTP code');
      return;
    }

    if (newPassword.text != confirmPassword.text) {
      StatusSnackbar.showError(message: 'Passwords do not match');
      return;
    }

    if (identifier.value.isEmpty) {
      StatusSnackbar.showError(message: 'Missing user identifier. Please try again.');
      return;
    }

    try {
      // Use loading dialog/overlay
      FullScreenLoader.show(
        text: 'Resetting Password...',
        animation: TAnimations.pencilDrawing,
      ); // Need to import if used

      await _authService.resetPassword(
        identifier: identifier.value,
        otp: otp,
        newPassword: newPassword.text,
        newPasswordConfirm: confirmPassword.text,
      );

      FullScreenLoader.hide();

      StatusSnackbar.showSuccess(message: 'Password reset successfully. Please login.');
      Get.offAllNamed(
        Routes.LOGIN,
      ); // Using route name assuming it's standard, or redirect to LoginScreen()
    } catch (e) {
      FullScreenLoader.hide();
      StatusSnackbar.showError(message: e.toString());
    }
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

  @override
  void onClose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
