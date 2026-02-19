import 'package:get/get.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/models/chat/chat_room_model.dart';
import 'package:tasklink/services/chat/chat_service.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/routes/routes.dart';

class ChatListController extends GetxController {
  final ChatService _chatService = ChatService();
  final RxList<ChatRoomModel> rooms = <ChatRoomModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  /// Participant set key so (A,B) and (B,A) map to the same key.
  static String _participantKey(ChatRoomModel r) {
    final a = r.poster?.id ?? '';
    final b = r.tasker?.id ?? '';
    return a.compareTo(b) <= 0 ? '$a|$b' : '$b|$a';
  }

  /// Merge rooms that have the same two participants (one entry per user pair).
  static List<ChatRoomModel> _mergeRoomsByParticipant(List<ChatRoomModel> list) {
    if (list.isEmpty) return list;
    final map = <String, List<ChatRoomModel>>{};
    for (final r in list) {
      final key = _participantKey(r);
      map.putIfAbsent(key, () => []).add(r);
    }
    final merged = <ChatRoomModel>[];
    for (final group in map.values) {
      if (group.length == 1) {
        merged.add(group.first);
        continue;
      }
      // Sort by last message time (has message first), then by created_at
      group.sort((a, b) {
        final aTime = a.lastMessage?.createdAt ?? a.createdAt ?? DateTime(0);
        final bTime = b.lastMessage?.createdAt ?? b.createdAt ?? DateTime(0);
        return bTime.compareTo(aTime);
      });
      final first = group.first;
      final allTasks = <ChatRoomActiveTask>[];
      final seenIds = <String>{};
      int totalUnread = 0;
      ChatLastMessageModel? latestMessage;
      DateTime? latestAt;
      for (final r in group) {
        totalUnread += r.unreadCount;
        for (final t in r.activeTasks) {
          if (seenIds.add(t.id)) allTasks.add(t);
        }
        final msg = r.lastMessage;
        if (msg?.createdAt != null &&
            (latestAt == null || msg!.createdAt!.isAfter(latestAt))) {
          latestAt = msg!.createdAt;
          latestMessage = msg;
        }
      }
      merged.add(ChatRoomModel(
        id: first.id,
        taskId: first.taskId,
        taskTitle: first.taskTitle,
        activeTasks: allTasks,
        poster: first.poster,
        tasker: first.tasker,
        lastMessage: latestMessage ?? first.lastMessage,
        unreadCount: totalUnread,
        createdAt: first.createdAt,
      ));
    }
    merged.sort((a, b) {
      final aTime = a.lastMessage?.createdAt ?? a.createdAt ?? DateTime(0);
      final bTime = b.lastMessage?.createdAt ?? b.createdAt ?? DateTime(0);
      return bTime.compareTo(aTime);
    });
    return merged;
  }

  Future<void> fetchRooms() async {
    isLoading.value = true;
    try {
      final list = await _chatService.getMyRooms();
      rooms.assignAll(_mergeRoomsByParticipant(list));
    } catch (e) {
      StatusSnackbar.showError(message: 'Failed to load chat rooms: $e');
    }
    isLoading.value = false;
  }

  void openChat(ChatRoomModel room) {
    final currentUserId = UserController.instance.currentUser.value?.id ?? '';
    final other = room.otherParticipant(currentUserId);
    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        'roomId': room.id,
        'taskTitle': room.displayTitle,
        'taskId': room.taskId,
        'activeTasks': room.activeTasks,
        'otherUser': other,
      },
    );
  }
}
