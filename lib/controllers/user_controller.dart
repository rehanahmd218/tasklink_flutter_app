import 'package:get/get.dart';
import 'package:tasklink/authentication/models/user_model.dart';
import 'package:tasklink/authentication/screens/blocked_screen/blocked_screen.dart';
import 'package:tasklink/authentication/screens/login_screen/login_screen.dart';
import 'package:tasklink/controllers/location/location_controller.dart';
import 'package:tasklink/navigation_menu.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/services/authentication/auth_service.dart';
import 'package:tasklink/utils/local_storage/storage_helper.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _authService = AuthService();

  // Observable current user - accessible globally
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Computed property to check if user is logged in
  bool get isLoggedIn => currentUser.value != null;

  /// Update the global user state
  void setUser(UserModel user) {
    currentUser.value = user;
  }

  bool get isPhoneVerified => currentUser.value?.isPhoneVerified ?? false;

  bool get isEmailVerified => currentUser.value?.isEmailVerified ?? false;

  /// Fetch user profile from API (used on app start)
  Future<void> fetchUserProfile() async {
    try {
      final user = await _authService.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      // If unauthorized or error, clear tokens
      await StorageHelper.clearTokens();
      currentUser.value = null;
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Show loading if needed, or just do it
      // Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      await _authService.logout();
      await clearUser();

      // Get.back(); // Close dialog if used
      redirectBasedOnStatus();
    } catch (e) {
      // Get.back();
      await clearUser();
      redirectBasedOnStatus();
    }
  }

  /// Clear user on logout
  Future<void> clearUser() async {
    currentUser.value = null;
    await StorageHelper.clearTokens();
  }

  /// Redirect logic based on user status
  void redirectBasedOnStatus() async {
    final user = currentUser.value;

    if (user == null) {
      Get.offAll(() => const LoginScreen());
      return;
    }

    // Check if user is blocked
    // Assuming isActive is false when blocked.
    if (user.isActive == false) {
      Get.offAll(() => const BlockedScreen());
      return;
    }

    // Check verification status
    if (!user.isPhoneVerified) {
      // Navigate to phone verification
      Get.offAllNamed(
        Routes.VERIFICATION,
        arguments: {'type': 'phone', 'target': user.phoneNumber},
      );
      return;
    }

    // Check email verification status
    if (!user.isEmailVerified) {
      // Navigate to email verification
      Get.offAllNamed(
        Routes.VERIFICATION,
        arguments: {'type': 'email', 'target': user.email},
      );
      return;
    }

    final locationController = LocationController.instance;
    locationController.sendLocationToBackend();

    Get.offAll(() => const NavigationMenu());
  }
}
