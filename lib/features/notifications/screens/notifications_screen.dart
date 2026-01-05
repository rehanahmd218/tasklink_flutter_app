import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/notifications/screens/widgets/notification_filter_chip.dart';
import 'package:tasklink/features/notifications/screens/widgets/notification_item.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Notifications',
        actions: [
          TextButton(
            onPressed: () {}, 
            child: Text('Mark all as read', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? Colors.grey[400] : Colors.grey[600]))
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!))),
            child: Row(
              children: [
                NotificationFilterChip(label: 'All', isSelected: true, isDark: isDark),
                const SizedBox(width: 8),
                NotificationFilterChip(label: 'Bids', isSelected: false, isDark: isDark),
                const SizedBox(width: 8),
                NotificationFilterChip(label: 'Tasks', isSelected: false, isDark: isDark),
                const SizedBox(width: 8),
                NotificationFilterChip(label: 'System', isSelected: false, isDark: isDark),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                NotificationItem(
                  type: 'Bid',
                  title: 'New Bid: Lawn Mowing',
                  time: '5m ago',
                  description: "John D. placed a bid of \$50",
                  highlight: '\$50',
                  avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDMK-jv8ok3AIgcIZMo7g1akc3oEKH1LwvdjF4RjGwb4-K-K3IqmpkSGgB7ofhRHkVMWzfxQ4WJoizF8lXcRJTA91XsM3CGJOmZtm__EGFwRNAONM6wA8chSMkRoCXjHVNxb2-a3XI0wJXhFMgTZz78vnyGUKVM61Rpcftm1D_yUq8G5QIubTM5Gv8KYIAq_vRt0Qgue004pprZCZMmiUcv0zmGD8JZS4qMEel47h0BsiM7_j2HPbomlBYVWlVtAb285Gp_D8gRJQrg',
                  isUnread: true,
                  isDark: isDark,
                ),
                Container(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]),
                NotificationItem(
                  type: 'System',
                  title: 'Action Required',
                  time: '1h ago',
                  description: "Please update your payment method to continue posting tasks.",
                  isUnread: true,
                  isDark: isDark,
                  icon: Icons.warning_amber_rounded,
                ),
                Container(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]),
                NotificationItem(
                  type: 'Task',
                  title: 'Task Completed',
                  time: '2h ago',
                  description: "You marked 'Fix Kitchen Sink' as complete.",
                  isUnread: false,
                  isDark: isDark,
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  iconBg: Colors.green[50],
                ),
                Container(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]),
                NotificationItem(
                  type: 'Wallet',
                  title: 'Wallet Update',
                  time: '1d ago',
                  description: "Funds released for 'Dog Walking Service'.",
                  isUnread: false,
                  isDark: isDark,
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: Colors.blue,
                  iconBg: Colors.blue[50],
                ),
                Container(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]),
                NotificationItem(
                  type: 'Message',
                  title: 'New Message',
                  time: '1d ago',
                  description: 'Sarah K: "Are you available this weekend?"',
                  isUnread: false,
                  isDark: isDark,
                  avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDcJULI1uxPaPwaao4aMsI5CIdUrpl7Z09wGqScSzrVhlkcv6_1RBePQxFg37Jzh73TeJhQ4qUwREDIdiIKy4sMSIFe2ZzczNx5R5tX_ktpxrNhun0NLNAqzwKXX9MpJff-Z7Qyizknb_I6BH9IsvXqpDaFHKMMgj9A90jWZym0CwZdraA5kXG9ZBJWf70Rm6Ny90zRsstp2t1Or4EqS8uFQOIrwHPNh2UVKV-nktDU9nbCVbR8ZEq0XNpI_Mr3FujubA8FSsxDWyyB',
                ),
                Container(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]),
                NotificationItem(
                  type: 'System',
                  title: 'System Maintenance',
                  time: '2d ago',
                  description: "Scheduled maintenance on Sunday 2am - 4am.",
                  isUnread: false,
                  isDark: isDark,
                  icon: Icons.settings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
