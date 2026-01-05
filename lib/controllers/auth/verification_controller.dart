import 'package:get/get.dart';
import 'dart:async';

class VerificationController extends GetxController {
  final otp = ''.obs;
  final timerText = '00:30'.obs;
  final isResendEnabled = false.obs;
  Timer? _timer;
  int _start = 30;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _start = 30;
    isResendEnabled.value = false;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          isResendEnabled.value = true;
        } else {
          _start--;
          int minutes = _start ~/ 60;
          int seconds = _start % 60;
          timerText.value = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
      },
    );
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
