import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
 // Still removing this
import 'package:google_fonts/google_fonts.dart';

/// Bottom navigation bar matching HTML design exactly
/// 5 tabs: Home, My Tasks, Chat, Wallet, Profile
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                onTap: onTap,
                isDark: isDark,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.task_alt_outlined,
                activeIcon: Icons.task_alt,
                label: 'My Tasks',
                onTap: onTap,
                isDark: isDark,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: 'Chat',
                onTap: onTap,
                isDark: isDark,
                showBadge: true,
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: 'Wallet',
                onTap: onTap,
                isDark: isDark,
              ),
              _NavItem(
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                onTap: onTap,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Function(int) onTap;
  final bool isDark;
  final bool showBadge;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.showBadge = false,
  });

  bool get isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? TColors.primary : TColors.textPrimary;
    final inactiveColor = TColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Icon with active background
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: TColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      activeIcon,
                      color: isDark ? TColors.primary : TColors.textPrimary,
                      size: 24,
                    ),
                  )
                else
                  Icon(
                    icon,
                    color: inactiveColor,
                    size: 24,
                  ),
                // Badge for Chat
                if (showBadge && !isActive)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: TColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? TColors.darkContainer : TColors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isActive ? activeColor : inactiveColor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 10, // labelSmall
              ),
            ),
          ],
        ),
      ),
    );
  }
}

