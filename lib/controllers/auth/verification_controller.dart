import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader_with_button.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/services/authentication/auth_service.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

enum VerificationType { EMAIL, PHONE }

class VerificationController extends GetxController {
  // Arguments passed from previous screen
  late final VerificationType type;
  late final String? target; // phone number or email address to display

  final otp = ''.obs;
  final timerText = '00:30'.obs;
  final isResendEnabled = false.obs;
  Timer? _timer;
  int _start = 30;

  final AuthService _authService = AuthService();
  final isLoading = false.obs;
  bool _isSendingOtp = false;

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      type = args['type'] == 'email'
          ? VerificationType.EMAIL
          : VerificationType.PHONE;
      target = args['target'];
    } else {
      // Default to phone if no args (fallback logic) or throw error
      // Better to check user controller if available
      final user = UserController.instance.currentUser.value;
      if (user != null && !user.isPhoneVerified) {
        type = VerificationType.PHONE;
        target = user.phoneNumber;
      } else if (user != null && !user.isEmailVerified) {
        type = VerificationType.EMAIL;
        target = user.email;
      } else {
        type = VerificationType.PHONE;
        target = '';
      }
    }

    startTimer();

    // Optionally send OTP immediately on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendOtp();
    });
  }

  void startTimer() {
    _start = 30;
    isResendEnabled.value = false;
    _timer?.cancel(); // Cancel existing timer if any
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        timer.cancel();
        isResendEnabled.value = true;
        timerText.value = "00:00";
      } else {
        _start--;
        int minutes = _start ~/ 60;
        int seconds = _start % 60;
        timerText.value =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    });
  }

  /// Send OTP
  Future<void> sendOtp() async {
    if (_isSendingOtp) return;
    _isSendingOtp = true;
    try {
      FullScreenLoader.show(
        text: 'Sending Code...',
        animation: TAnimations.otpAnimation,
      );

      // Call API
      await _authService.sendOtp(
        type: type == VerificationType.EMAIL ? 'email' : 'phone',
      );
      FullScreenLoader.hide();
      StatusSnackbar.showSuccess(message: 'OTP sent successfully to $target');

      // Reset timer only after successful send
      startTimer();
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e);
    } finally {
      _isSendingOtp = false;
    }
  }

  /// Verify OTP
  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      StatusSnackbar.showError(message: 'Please enter a valid 6-digit OTP');
      return;
    }

    try {
      // Use LoadingOverlay in UI via isLoading variable
      isLoading.value = true;

      await _authService.verifyOtp(
        type: type == VerificationType.EMAIL ? 'email' : 'phone',
        otp: otp.value,
      );

      isLoading.value = false;

      // Update local user state instead of making a redundant API call
      final currentUser = UserController.instance.currentUser.value;
      if (currentUser != null) {
        if (type == VerificationType.EMAIL) {
          currentUser.isEmailVerified = true;
        } else {
          currentUser.isPhoneVerified = true;
        }
        UserController.instance.currentUser.refresh();
      }
      
      FullScreenLoaderWithButton.show(
        text: 'OTP verified successfully!',
        animation: TAnimations.greenTickAnimation2,
        buttonText: 'Continue',
        onButtonPressed: () {
          FullScreenLoaderWithButton.hide();
          UserController.instance.redirectBasedOnStatus();
        },
      );
    } catch (e) {
      isLoading.value = false;
      FullScreenLoaderWithButton.hide();
      ErrorHandler.showErrorPopup(e, buttonText: 'Try Again');
    }
  }

  void addDigit(String digit) {
    if (otp.value.length < 6) {
      otp.value += digit;
    }
  }

  void removeDigit() {
    if (otp.value.isNotEmpty) {
      otp.value = otp.value.substring(0, otp.value.length - 1);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
