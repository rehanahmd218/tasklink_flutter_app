import 'package:get/get.dart';
import 'package:tasklink/authentication/screens/login_screen/login_screen.dart';
import 'package:tasklink/controllers/location/location_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';

import 'package:tasklink/utils/local_storage/storage_helper.dart';

class SplashScreenController extends GetxController {
  @override
  void onReady() async {
    super.onReady();

    // 1. Fetch Location Requirement (Blocking)
    // We wait until we get a valid location.
    await LocationController.instance.checkAndGetLocation();

    // If location is not yet fetched (e.g. user is seeing a popup), wait for it.
    if (LocationController.instance.latitude.value == 0.0) {
      await LocationController.instance.latitude.stream.firstWhere(
        (val) => val != 0.0,
      );
    }

    // Check for stored tokens
    final hasTokens = await StorageHelper.hasTokens();

    if (hasTokens) {
      try {
        await StorageHelper.initCache();
        // Fetch fresh user profile
        await UserController.instance.fetchUserProfile();

        // Navigate based on status
        UserController.instance.redirectBasedOnStatus();
      } catch (e) {
        // If fetch fails (e.g. token expired), go to login
        Get.offAll(() => const LoginScreen());
      }
    } else {
      // No tokens, go to login
      Get.offAll(() => const LoginScreen());
    }
  }
}
