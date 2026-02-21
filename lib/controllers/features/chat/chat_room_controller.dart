import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
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
  final RxList<ChatRoomActiveTask> activeTasks = <ChatRoomActiveTask>[].obs;
  final Rxn<TaskResponseUserModel> otherUser = Rxn<TaskResponseUserModel>();
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final Rx<ChatConnectionStatus> connectionStatus =
      Rx<ChatConnectionStatus>(ChatConnectionStatus.disconnected);
  final RxBool isLoading = true.obs;
  final RxBool isSending = false.obs;
  final RxBool isUploadingMedia = false.obs;
  final RxList<String> pendingMediaIds = <String>[].obs;

  ChatWebSocketService? _ws;
  StreamSubscription? _msgSub;
  StreamSubscription? _statusSub;
  StreamSubscription? _errorSub;

  /// Called when a new message is added (e.g. from WebSocket). Used by UI to scroll to bottom if needed.
  void Function()? onMessageAdded;

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
    if (args['activeTasks'] is List) {
      final list = <ChatRoomActiveTask>[];
      for (final e in args['activeTasks'] as List) {
        if (e is ChatRoomActiveTask) {
          list.add(e);
        } else if (e is Map) {
          list.add(ChatRoomActiveTask.fromJson(Map<String, dynamic>.from(e)));
        }
      }
      activeTasks.assignAll(list);
    }

    if (rid == null && taskId != null) {
      isLoading.value = true;
      try {
        final roomList = await _chatService.getMyRooms();
        ChatRoomModel? match;
        for (final r in roomList) {
          if (r.hasTask(taskId)) {
            match = r;
            break;
          }
        }
        match ??= await _chatService.getOrCreateChatRoomForTask(taskId);
        rid = match.id;
        if (taskTitle.value.isEmpty) taskTitle.value = match.displayTitle;
        activeTasks.assignAll(match.activeTasks);
        final currentUserId = UserController.instance.currentUser.value?.id;
        if (currentUserId != null && otherUser.value == null) {
          otherUser.value = match.otherParticipant(currentUserId);
        }
            } catch (e) {
        StatusSnackbar.showError(message: 'Failed to find or create chat room: $e');
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
      StatusSnackbar.showError(message: 'Failed to load messages: $e');
      
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
      onMessageAdded?.call();
    });
    _statusSub = _ws!.statusStream.listen((s) {
      connectionStatus.value = s;
    });
    _errorSub = _ws!.errorStream.listen((err) {
      StatusSnackbar.showError(message: err);
    });
    _ws!.connect(rid);
  }

  void sendMessage(String text, {List<String>? mediaIds}) {
    if (_ws == null || !_ws!.isConnected) {
      StatusSnackbar.showWarning(message: 'Not connected');
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
      isUploadingMedia.value = true;
      final id = await _chatService.uploadMessageMedia(rid, file, mediaType: mediaType);
      pendingMediaIds.add(id);
    } catch (e) {
      StatusSnackbar.showError(message: 'Failed to upload media: $e');
    } finally {
      isUploadingMedia.value = false;
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
