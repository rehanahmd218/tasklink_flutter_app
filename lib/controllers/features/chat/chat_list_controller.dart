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

  Future<void> fetchRooms() async {
    isLoading.value = true;
    try {
      final list = await _chatService.getMyRooms();
      rooms.assignAll(list);
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
