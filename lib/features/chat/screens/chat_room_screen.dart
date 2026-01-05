import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_image_bubble.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_input_area.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_message_bubble.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_task_header.dart';
import 'package:tasklink/features/chat/screens/widgets/chat_typing_indicator.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFfcfcf8),
      appBar: PrimaryAppBar(
        titleWidget: Column(
          children: [
            Text('Alex M.', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('Online', style: GoogleFonts.inter(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.black), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ChatTaskHeader(taskName: 'Assemble IKEA Desk'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                    child: Text('You started a chat with Alex M. • Today 1:24 PM', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 24),
                const ChatMessageBubble(
                  message: "Hi! I saw your request for the desk assembly. Is it the large corner desk?",
                  time: '1:30 PM',
                  isMe: false,
                  avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCvTo_VmGcJEbMsK-DMupI3mKufrnwRYFFamhP2P6Vw1ISHrZRAjqSBWKfBecKFA5VNBPDpDxdrSCEuSRbSJ4H9DeCiXyPiE0eElh0eZjXcRetzvKNYU-5wFedR31mrFewwkTPCXzAdMwGUpLt2gXRzG5S3yf28F90g5KCgw1B_YCEYCf1wjJGUWkF8s9hOHAFRMWpZAKG3ki3YkurUUhulSjO65N7QSx5tTz06pAqMi5KsbSrLZT6ALGonfetA9nVgseAC02IRrL6J',
                ),
                const ChatMessageBubble(
                  message: "Hey! Yes, it's the L-shaped one. Do you have tools?",
                  time: '1:32 PM',
                  isMe: true,
                  isRead: true,
                ),
                const ChatMessageBubble(
                  message: "Absolutely. I have my own power drill and screwdrivers. I can be there by 2 PM if that works?",
                  time: '1:35 PM',
                  isMe: false,
                   avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCs5W7VlV1ZiQI42yb11E26jrWBPodLHYnNGT4HJIUUlE_dE2A7Jb1R-_aJEZ9cb37H0FV2HkagvKJwrXa6LUUdD5lP5OoC1r16z29NAG3DGy4DZ_Tzex-IbZf5h5qzNws-ZmzxCQxX3XtSnSeEWqkCZpDIMQiwHc9TUB8B1kasNK89kCcvdVFhnWl3u7caLHBLUsFObvOa4rBQ2c0cJFE875r9pyVG5sGHexO56vTp3tnhDUK7Yw4tc3Vji9no7cWuWayTHoejsw3T',
                ),
                const ChatImageBubble(
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDvJwXl2ebvrcz_9znTBHrrM6LRKIUrE3saEdGDU8--nDdF4nqCdZuhfKpSNrEalFbmfocmE5nt-Zoe4oemfnO1GugoSrwl-FM8epSrU_kWSkZNWKabbFi1pCEzDUMMzRd1LXPhZL-EXTOTahFJspB8ebJ3YOwp7cY5rhWSnV5qxhF-85HtjsDVhsVQ7J9uUGvmLQcoS1aEkiG5pJGqastFfgBbuuBoDA8ck2Csvtkg7vR-5Ea3MEl091f0CGIWH9IptQjVIrFhlIum',
                  time: '1:36 PM',
                  isMe: true,
                  isRead: true,
                ),
                const ChatMessageBubble(
                  message: "Perfect, see you then!",
                  time: '1:36 PM',
                  isMe: true,
                  isRead: true,
                ),
                 // Typing indicator
                const ChatTypingIndicator(avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD6QDuLeso_YAmeea40LgFNhZfUl5Y-2bazky6Pj6FpdTWpwSsRwwuYu2YjZuR5xn02g73F6J3YicB0p-HozLVGK2cw4zhhpT_k1k6R2xNEdUSSMdAApc44cbuD85R9H-RFVIRHQfF51IQJ-FckNzuHY8mSpvRwwrhqIV9C-KC3QMQGkOVWzPlESDg6NQvcQTYNP1pdNolpWurOKi_WCTEdbDh_t1GkoWNJbNZijb-ldxMi-T7b6JLiajBHsEDsRA0EUudWW0OXngw3'),
              ],
            ),
          ),
          
          // Input
          const ChatInputArea(),
        ],
      ),
    );
  }
}
