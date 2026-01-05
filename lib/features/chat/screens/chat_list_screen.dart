import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_filter_chip.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_list_item.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Chats',
        showBackButton: false,
        centerTitle: false,
        actions: [
          Container(
             margin: const EdgeInsets.only(right: 16),
             decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white, shape: BoxShape.circle),
             child: IconButton(icon: Icon(Icons.edit, color: isDark ? Colors.white : Colors.black), onPressed: () {}),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                 hintText: 'Search messages...',
                 hintStyle: GoogleFonts.inter(color: Colors.grey),
                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
                 filled: true,
                 fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                 contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
      body: Column(
        children: [

          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                  ChatFilterChip(label: 'All', isSelected: true, onTap: () {}),
                  ChatFilterChip(label: 'Taskers', isSelected: false, onTap: () {}),
                  ChatFilterChip(label: 'Posters', isSelected: false, onTap: () {}),
                  ChatFilterChip(label: 'Archived', isSelected: false, onTap: () {}),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ChatListItem(
                  name: 'Alex D. (Tasker)',
                  message: "I'm on my way to the location now...",
                  time: '10:45 AM',
                  avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBq4N9jRLhkOiNgZ4WMGxskWpU7-Vjm0xU3erezqBkqX7dVbDR7J4eQcEBWG_MOBX6OqdgSOPj9_eiOXxoeHOkk8mc_Uli7I-CMhDKAUm9ymNDWEJR9pxsLoHnwYV9ae6NoP1wdD306lZw3OjmhpX_-Pf2D8yn_SWp6UgLSQQtIcHsXE4AJLfVcmp6C-KdTWvAslVE5GvNPspmSvB09uNZU0jNWf-1VDJhvM0UNZ2QC3AFSBjBxz4T-3mkSjn2lOeEaHH3SVX8VQwEa',
                  isOnline: true,
                  unreadCount: 2,
                  contextLabel: 'Moving Help • Scheduled Today',
                  contextIcon: Icons.local_shipping,
                  onTap: () => Get.to(() => const ChatRoomScreen()),
                ),
                ChatListItem(
                  name: 'Sarah J. (Poster)',
                  message: "Can you confirm the price for the lawn mowing?",
                  time: 'Yesterday',
                  avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDBgKPTAm99o5cB027FGU3HKq54CVBGTh_6TZ33cP2hJJYt0pdyKLd7oscCiMaUcI6fTpUU4mZgeltvjMl-XHkkXmQ8sH_j-r5uHuyttJ6Iy3HevzNhnuc7cCCRb19kvqKSB6k83YC6rEY1C7S-BdtTJNn-PbRw7USKupd5zdLEvMbXX_lSws03P9sUKoherS8xXTZ7ANNyqFhiuqhuKhoz5Lh_Vycr3LxkV-cIYCjuL9JKT1XBQRpCYtUieSA8NRzE7gPVn0IZf_5s',
                  contextLabel: 'Lawn Mowing',
                  contextIcon: Icons.yard,
                ),
                 ChatListItem(
                  name: 'Mike R. (Tasker)',
                  message: "The shelf assembly is complete!",
                  time: 'Mon',
                  avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBgTNpHLinwJsv5TZW5wDgwcObRSBrdAEPBs89WAQ4y5DuMNYbmGGEc5csFPEoIfGXKfApnPS-VoYcWT1xQJetj1lLxb6SpmFQVfmNnvyjx73u7p3x8aLu5rLPBcqYQhCnf_wPlnxxkFSlvvprv23MG1XtKcCEP8QP3lNQW7B0FwkDahwWlldrQsWUZx2TBXyNgZJ1SqhLziJ8L1dkPVU0AlD8u6NG3dFtRj6Y6FqajjjZRbMfZqv9S8Dpwjj4XYPiEAofqSmgX4URm',
                  contextLabel: 'Furniture Assembly',
                  contextIcon: Icons.build,
                  isRead: true,
                ),
                ChatListItem(
                  name: 'Jessica L. (Poster)',
                  message: "Is 2 PM okay for pickup?",
                  time: 'Sun',
                  initials: 'JL',
                  unreadCount: 1,
                  contextLabel: 'Grocery Delivery',
                  contextIcon: Icons.shopping_bag,
                  isOnline: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
