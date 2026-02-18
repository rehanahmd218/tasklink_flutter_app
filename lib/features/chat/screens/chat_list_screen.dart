import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasklink/controllers/features/chat/chat_list_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_filter_chip.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_list_item.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/utils/constants/colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  static String _formatListTime(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return DateFormat('h:mm a').format(date);
    if (now.difference(d).inDays == 1) return 'Yesterday';
    if (now.difference(d).inDays < 7) return DateFormat('EEE').format(date);
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(ChatListController());

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Chats',
        showBackButton: false,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.edit, color: isDark ? Colors.white : Colors.black),
              onPressed: () {},
            ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
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
            child: Obx(() {
              if (controller.isLoading.value && controller.rooms.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: TColors.primary));
              }
              if (controller.rooms.isEmpty) {
                return Center(
                  child: Text(
                    'No chats yet',
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchRooms,
                color: TColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.rooms.length,
                  itemBuilder: (context, index) {
                    final room = controller.rooms[index];
                    final other = room.otherParticipant(
                      UserController.instance.currentUser.value?.id ?? '',
                    );
                    final name = other?.displayName ?? 'Chat';
                    final last = room.lastMessage;
                    final message = last?.text ?? '';
                    final time = _formatListTime(last?.createdAt);
                    return ChatListItem(
                      name: name,
                      message: message,
                      time: time,
                      avatarUrl: other?.profileImage,
                      initials: name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
                      unreadCount: room.unreadCount,
                      contextLabel: room.displayTitle,
                      contextIcon: Icons.task_alt,
                      isRead: room.unreadCount == 0,
                      onTap: () => controller.openChat(room),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
