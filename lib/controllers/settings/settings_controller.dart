import 'package:get/get.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/controllers/features/tasks/my_posted_tasks_controller.dart';
import 'package:tasklink/controllers/features/tasks/tasks_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/services/user/user_service.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  final UserService _userService = UserService();
  final UserController _userController = UserController.instance;

  final isLoading = false.obs;

  /// Update user role (e.g., switch between POSTER and TASKER)
  Future<void> updateUserRole(String newRole) async {
    try {
      FullScreenLoader.show(text: 'Updating role...');
      isLoading.value = true;

      final updatedUser = await _userService.updateRole(newRole);

      // Update global user state
      _userController.setUser(updatedUser);

      // Invalidate tasks-screen controllers so My Tasks re-initializes with new role and fresh data
      if (Get.isRegistered<MyPostedTasksController>()) {
        Get.delete<MyPostedTasksController>();
      }
      if (Get.isRegistered<TasksController>()) {
        Get.delete<TasksController>();
      }
      if (Get.isRegistered<BidController>()) {
        Get.delete<BidController>();
      }

      FullScreenLoader.hide();

      StatusSnackbar.showSuccess(
        message: 'Role updated to $newRole successfully.',
      );
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    } finally {
      isLoading.value = false;
    }
  }
}
