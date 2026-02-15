import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/features/navigation_controller.dart';
import 'package:tasklink/features/chat/screens/chat_list_screen.dart';
import 'package:tasklink/features/home/screens/home_screen.dart';
import 'package:tasklink/features/tasks/my_tasks/screens/my_tasks_screen.dart';
import 'package:tasklink/features/profile/screens/profile_screen.dart';
import 'package:tasklink/features/wallet/screens/wallet_screen.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/my_posted_tasks_screen.dart';
import 'package:tasklink/utils/constants/colors.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarAndToolbar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          isDark: isDark,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationBarAndToolbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isDark;

  const NavigationBarAndToolbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23220f) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey[200]!,
          ),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ), // Adjusted for safe area usually
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            _buildNavItem(0, Icons.home_rounded, "Home"),
            _buildNavItem(1, Icons.assignment_rounded, "My Tasks"),
            _buildNavItem(2, Icons.chat, "Chat"),

            _buildNavItem(3, Icons.account_balance_wallet_rounded, "Wallet"),
            _buildNavItem(
              4,
              Icons.person_outline_rounded,
              "Profile",
            ), // Changed Bids to Profile and moved Wallet
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onDestinationSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: isSelected
                ? BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : TColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: Icon(
              icon,
              size: 24,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF1c1c0d))
                  : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF1c1c0d))
                  : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
