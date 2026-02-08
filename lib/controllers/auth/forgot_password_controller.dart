import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/authentication/screens/reset_password_screen/reset_password_screen.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/services/authentication/auth_service.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

class ForgotPasswordController extends GetxController {
  final email = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> sendResetCode() async {
    if (!formKey.currentState!.validate()) return;

    try {
      FullScreenLoader.show(
        text: 'Sending OTP...',
        animation: TAnimations.otpAnimation,
      );

      await _authService.sendPasswordResetOtp(identifier: email.text.trim());

      FullScreenLoader.hide();
      StatusSnackbar.showSuccess(message: 'OTP sent to your email.');

      // Navigate to Reset Password Screen with the email/identifier
      Get.to(
        () => const ResetPasswordScreen(),
        arguments: {'identifier': email.text.trim()},
      );
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e);
    }
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}
