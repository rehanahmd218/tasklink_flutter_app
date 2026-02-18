import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasklink/controllers/features/chat/chat_room_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_image_bubble.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_input_area.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_message_bubble.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_task_header.dart';
import 'package:tasklink/services/chat/chat_websocket_service.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/utils/http/api_config.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  static String _formatMessageTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = true;
  bool _initialScrollDone = false;
  static const double _scrollThreshold = 80;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    final atBottom = offset >= max - _scrollThreshold;
    if (atBottom != _isAtBottom && mounted) {
      setState(() => _isAtBottom = atBottom);
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    if (!_isAtBottom && mounted) setState(() => _isAtBottom = true);
  }

  @override
  void dispose() {
    try {
      final controller = Get.find<ChatRoomController>();
      controller.onMessageAdded = null;
    } catch (_) {}
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    Get.delete<ChatRoomController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(ChatRoomController());
    final currentUserId = UserController.instance.currentUser.value?.id ?? '';

    // When a new message is added (receive or send), scroll to bottom if user was at bottom or if they sent it
    controller.onMessageAdded = () {
      if (!mounted) return;
      final fromMe = controller.messages.isNotEmpty &&
          controller.messages.last.sender.id == currentUserId;
      if (_isAtBottom || fromMe) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    };

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFfcfcf8),
      appBar: PrimaryAppBar(
        titleWidget: Obx(() {
          final other = controller.otherUser.value;
          final name = other?.displayName ?? 'Chat';
          final status = controller.connectionStatus.value;
          return Column(
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: status == ChatConnectionStatus.connected
                          ? Colors.green
                          : status == ChatConnectionStatus.connecting
                              ? Colors.orange
                              : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status == ChatConnectionStatus.connected
                        ? 'Online'
                        : status == ChatConnectionStatus.connecting
                            ? 'Connecting...'
                            : 'Offline',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: status == ChatConnectionStatus.connected
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Obx(() => ChatTaskHeader(
                taskName: controller.taskTitle.value,
                activeTasks: controller.activeTasks.toList(),
              )),
        ),
      ),
      body: Obx(() {
        if (controller.roomId.value == null && !controller.isLoading.value) {
          return const Center(
            child: Text('No chat for this task'),
          );
        }
        if (controller.isLoading.value && controller.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // Scroll to bottom when initial messages load
        if (!_initialScrollDone && controller.messages.isNotEmpty) {
          _initialScrollDone = true;
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 72),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      final isMe = msg.sender.id == currentUserId;
                      final time = _formatMessageTime(msg.createdAt);
                      final avatarUrl = msg.sender.profileImage;
                      if (msg.media.isNotEmpty) {
                        final imageMedia = msg.media.where((m) => m.isImage).toList();
                        if (imageMedia.isNotEmpty) {
                          final firstImage = imageMedia.first;
                          final imageUrl = ApiConfig.mediaFileUrl(firstImage.file);
                          return ChatImageBubble(
                            imageUrl: imageUrl,
                            time: time,
                            isMe: isMe,
                            isRead: msg.isRead,
                          );
                        }
                      }
                      return ChatMessageBubble(
                        message: msg.messageText,
                        time: time,
                        isMe: isMe,
                        avatarUrl: avatarUrl,
                        isRead: msg.isRead,
                      );
                    },
                  ),
                ),
                ChatInputArea(
                  onSend: (text) {
                    controller.sendMessage(text);
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                    Future.delayed(const Duration(milliseconds: 400), _scrollToBottom);
                  },
                  onAttach: controller.attachFile,
                  isSending: controller.isSending.value,
                ),
              ],
            ),
            if (!_isAtBottom)
              Positioned(
                right: 16,
                bottom: 100,
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(24),
                  color: isDark ? const Color(0xFF2d2d1e) : Colors.white,
                  child: InkWell(
                    onTap: _scrollToBottom,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 28,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
