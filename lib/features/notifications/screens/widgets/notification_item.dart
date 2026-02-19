import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tasklink/models/notifications/notification_model.dart';
import '../../../../utils/constants/colors.dart';

class NotificationItem extends StatelessWidget {
  final String type;
  final String title;
  final String time;
  final String description;
  final String? highlight;
  final String? avatarUrl;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBg;
  final bool isUnread;
  final bool isDark;
  final VoidCallback? onDismiss;

  const NotificationItem({
    super.key,
    required this.type,
    required this.title,
    required this.time,
    required this.description,
    this.highlight,
    this.avatarUrl,
    this.icon,
    this.iconColor,
    this.iconBg,
    required this.isUnread,
    required this.isDark,
    this.onDismiss,
  });

  /// Build from API model. Tapping dismisses (mark as read).
  factory NotificationItem.fromModel(
    NotificationModel notification, {
    required bool isDark,
    VoidCallback? onDismiss,
  }) {
    final typeLabel = _typeLabel(notification.notificationType);
    IconData? iconData;
    Color? iconColor;
    Color? iconBg;
    if (notification.notificationType.contains('BID')) {
      iconData = Icons.gavel;
      iconBg = Colors.amber.shade50;
      iconColor = Colors.amber.shade700;
    } else if (notification.notificationType.contains('TASK') || notification.notificationType.contains('MESSAGE')) {
      iconData = Icons.task_alt;
      iconBg = Colors.blue.shade50;
      iconColor = Colors.blue.shade700;
    } else if (notification.notificationType.contains('DISPUTE') || notification.notificationType.contains('PAYMENT')) {
      iconData = Icons.account_balance_wallet_outlined;
      iconBg = Colors.green.shade50;
      iconColor = Colors.green.shade700;
    } else {
      iconData = Icons.notifications;
    }
    return NotificationItem(
      type: typeLabel,
      title: notification.title,
      time: notification.timeAgo,
      description: notification.body,
      isUnread: !notification.isRead,
      isDark: isDark,
      icon: iconData,
      iconColor: iconColor,
      iconBg: iconBg,
      onDismiss: onDismiss,
    );
  }

  static String _typeLabel(String notificationType) {
    if (notificationType.contains('BID')) return 'Bid';
    if (notificationType.contains('TASK') || notificationType.contains('MESSAGE')) return 'Task';
    if (notificationType.contains('DISPUTE')) return 'Dispute';
    if (notificationType.contains('PAYMENT') || notificationType.contains('REVIEW')) return 'System';
    return 'System';
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isUnread
        ? TColors.primary.withValues(alpha: isDark ? 0.05 : 0.1)
        : (isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5));
    final borderColor = isUnread ? TColors.primary : Colors.transparent;

    return InkWell(
      onTap: onDismiss,
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                  color: borderColor, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 12),
            if (avatarUrl != null)
              CircleAvatar(
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider(avatarUrl!))
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg ??
                      (isDark ? const Color(0xFF2c2b18) : Colors.white),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
                ),
                child: Icon(
                  icon ?? Icons.notifications,
                  color: iconColor ?? (isDark ? Colors.white : Colors.black),
                  size: 24,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1c1c0d)),
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: TColors.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark ? Colors.grey[300]! : Colors.grey[600]!,
                          height: 1.4),
                      children: [
                        TextSpan(
                            text: description
                                .replaceAll(highlight ?? '', '')),
                        if (highlight != null)
                          TextSpan(
                            text: highlight,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 12),
              Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: TColors.primary, shape: BoxShape.circle),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
