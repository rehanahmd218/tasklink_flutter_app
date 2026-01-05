import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/my_tasks_tabs.dart';

class MyTasksAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final String activeTab;
  final ValueChanged<String> onTabSelected;

  const MyTasksAppBar({
    super.key,
    required this.isDark,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'My Tasks',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: isDark ? Colors.white : const Color(0xFF1c1c0d),
        ),
      ),
      backgroundColor: (isDark ? const Color(0xFF18181b) : Colors.white).withValues(alpha: 0.8),
      elevation: 0,
       // NOTE: PrimaryAppBar forces centerTitle: true, but here we might want left aligned as per original? 
       // Original didn't specify centerTitle, so it defaults to platform.
       // Let's keep it as is or use PrimaryAppBar if we want consistency. 
       // For now, I'll extract this because it has custom bottom and actions specific to this screen.
       // Actually, I can use PrimaryAppBar if I pass flexible arguments, but this one has specific actions.
       // The plan was to "Review every screen... Apply CustomAppBar".
       // If I use PrimaryAppBar, I get back button logic (which I might not want for a main tab) and center title.
       // If MyTasks is a root screen (bottom nav), it shouldn't have back button.
       // PrimaryAppBar has showBackButton = true default.
      automaticallyImplyLeading: false, 
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MyTasksTabs(
                  activeTab: activeTab,
                  onTabSelected: onTabSelected,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search, color: isDark ? Colors.white : const Color(0xFF1c1c0d)), onPressed: () {}),
        Stack(
          children: [
            IconButton(icon: Icon(Icons.notifications_outlined, color: isDark ? Colors.white : const Color(0xFF1c1c0d)), onPressed: () {}),
            Positioned(top: 12, right: 12, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4), border: Border.all(color: isDark ? const Color(0xFF18181b) : Colors.white)))),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}
