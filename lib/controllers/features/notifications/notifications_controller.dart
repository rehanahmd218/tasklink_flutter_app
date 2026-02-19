import 'package:get/get.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/models/notifications/notification_model.dart';
import 'package:tasklink/services/notifications/notification_service.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUnreadNotifications();
    loadUnreadCount();
  }

  Future<void> loadUnreadNotifications() async {
    isLoading.value = true;
    error.value = '';
    try {
      final list = await _notificationService.getUnreadNotifications();
      notifications.assignAll(list);
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      notifications.clear();
    }
    isLoading.value = false;
  }

  Future<void> loadUnreadCount() async {
    try {
      final count = await _notificationService.getUnreadCount();
      unreadCount.value = count;
    } catch (_) {
      unreadCount.value = 0;
    }
  }

  /// Dismiss one notification (mark as read). Removes from list and updates count.
  Future<void> dismiss(NotificationModel notification) async {
    try {
      await _notificationService.markAsRead(notification.id);
      notifications.removeWhere((n) => n.id == notification.id);
      if (unreadCount.value > 0) unreadCount.value--;
    } catch (e) {
      StatusSnackbar.showError(message: 'Could not mark as read: $e');
    }
  }

  /// Mark all as read. Clears list and sets count to 0.
  Future<void> markAllAsRead() async {
    if (notifications.isEmpty) return;
    try {
      await _notificationService.markAllAsRead();
      notifications.clear();
      unreadCount.value = 0;
      StatusSnackbar.showSuccess(message: 'All notifications marked as read');
    } catch (e) {
      StatusSnackbar.showError(message: 'Could not mark all as read: $e');
    }
  }

  /// Refresh list and count (e.g. on pull-to-refresh).
  @override
  Future<void> refresh() async {
    await loadUnreadNotifications();
    await loadUnreadCount();
  }
}
