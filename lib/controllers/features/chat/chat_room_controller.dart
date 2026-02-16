import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:tasklink/models/chat/chat_message_model.dart';
import 'package:tasklink/models/chat/chat_room_model.dart';
import 'package:tasklink/models/tasks/task_response_user_model.dart';
import 'package:tasklink/services/chat/chat_service.dart';
import 'package:tasklink/services/chat/chat_websocket_service.dart';
import 'package:tasklink/controllers/user_controller.dart';

class ChatRoomController extends GetxController {
  final ChatService _chatService = ChatService();
  final Rx<String?> roomId = Rx<String?>(null);
  final Rx<String> taskTitle = Rx<String>('');
  final Rxn<TaskResponseUserModel> otherUser = Rxn<TaskResponseUserModel>();
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final Rx<ChatConnectionStatus> connectionStatus =
      Rx<ChatConnectionStatus>(ChatConnectionStatus.disconnected);
  final RxBool isLoading = true.obs;
  final RxBool isSending = false.obs;
  final RxList<String> pendingMediaIds = <String>[].obs;

  ChatWebSocketService? _ws;
  StreamSubscription? _msgSub;
  StreamSubscription? _statusSub;
  StreamSubscription? _errorSub;

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
  }

  Future<void> _initFromArguments() async {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    String? rid = args['roomId']?.toString();
    final taskId = args['taskId']?.toString();
    taskTitle.value = args['taskTitle']?.toString() ?? '';
    if (args['otherUser'] is TaskResponseUserModel) {
      otherUser.value = args['otherUser'] as TaskResponseUserModel;
    } else if (args['otherUser'] is Map) {
      otherUser.value =
          TaskResponseUserModel.fromJson(Map<String, dynamic>.from(args['otherUser'] as Map));
    }

    if (rid == null && taskId != null) {
      isLoading.value = true;
      try {
        final roomList = await _chatService.getMyRooms();
        ChatRoomModel? match;
        for (final r in roomList) {
          if (r.taskId == taskId) {
            match = r;
            break;
          }
        }
        if (match != null) {
          rid = match.id;
          if (taskTitle.value.isEmpty) taskTitle.value = match.taskTitle;
          final currentUserId = UserController.instance.currentUser.value?.id;
          if (currentUserId != null && otherUser.value == null) {
            otherUser.value = match.otherParticipant(currentUserId);
          }
        }
      } catch (e) {
        Get.snackbar('Error', 'Could not load chat: $e');
      }
      isLoading.value = false;
    }

    if (rid == null) {
      connectionStatus.value = ChatConnectionStatus.error;
      return;
    }
    roomId.value = rid;
    await loadMessages();
    _connectWebSocket();
  }

  Future<void> loadMessages() async {
    final rid = roomId.value;
    if (rid == null) return;
    isLoading.value = true;
    try {
      final list = await _chatService.getMessages(rid);
      messages.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages: $e');
    }
    isLoading.value = false;
  }

  void _connectWebSocket() {
    final rid = roomId.value;
    if (rid == null) return;
    _ws?.dispose();
    _ws = ChatWebSocketService();
    _msgSub = _ws!.messageStream.listen((msg) {
      messages.add(msg);
    });
    _statusSub = _ws!.statusStream.listen((s) {
      connectionStatus.value = s;
    });
    _errorSub = _ws!.errorStream.listen((err) {
      Get.snackbar('Chat', err);
    });
    _ws!.connect(rid);
  }

  void sendMessage(String text, {List<String>? mediaIds}) {
    if (_ws == null || !_ws!.isConnected) {
      Get.snackbar('Chat', 'Not connected');
      return;
    }
    final ids = mediaIds ?? (pendingMediaIds.isNotEmpty ? pendingMediaIds.toList() : null);
    isSending.value = true;
    _ws!.sendMessage(text, mediaIds: ids);
    if (ids != null && ids.isNotEmpty) pendingMediaIds.clear();
    isSending.value = false;
  }

  Future<void> attachFile(File file, {String mediaType = 'IMAGE'}) async {
    final rid = roomId.value;
    if (rid == null) return;
    try {
      final id = await _chatService.uploadMessageMedia(rid, file, mediaType: mediaType);
      pendingMediaIds.add(id);
    } catch (e) {
      Get.snackbar('Upload failed', e.toString());
    }
  }

  void removePendingMedia(String id) {
    pendingMediaIds.remove(id);
  }

  @override
  void onClose() {
    _msgSub?.cancel();
    _statusSub?.cancel();
    _errorSub?.cancel();
    _ws?.dispose();
    super.onClose();
  }
}
