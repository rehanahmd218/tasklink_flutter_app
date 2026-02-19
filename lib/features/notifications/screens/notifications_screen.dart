import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/notifications/screens/widgets/notification_item.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/notifications/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static Widget _buildSwipeBackground(
    BuildContext context,
    bool isDark,
    Alignment alignment,
  ) {
    return Container(
      alignment: alignment,
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = Get.put(NotificationsController());
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Notifications',
        actions: [
          Obx(() => TextButton(
                onPressed: ctrl.notifications.isEmpty
                    ? null
                    : () => ctrl.markAllAsRead(),
                child: Text(
                  'Mark all as read',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: ctrl.notifications.isEmpty
                        ? (isDark ? Colors.grey[600] : Colors.grey[400])
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.error.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ctrl.error.value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => ctrl.loadUnreadNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (ctrl.notifications.isEmpty) {
          return Center(
            child: Text(
              'No unread notifications',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ctrl.refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: ctrl.notifications.length,
            separatorBuilder: (_, __) => Container(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final n = ctrl.notifications[index];
              return Dismissible(
                key: ValueKey(n.id),
                direction: DismissDirection.horizontal,
                background: _buildSwipeBackground(context, isDark, Alignment.centerLeft),
                secondaryBackground: _buildSwipeBackground(context, isDark, Alignment.centerRight),
                onDismissed: (_) => ctrl.dismiss(n),
                child: NotificationItem.fromModel(
                  n,
                  isDark: isDark,
                  onDismiss: () => ctrl.dismiss(n),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
