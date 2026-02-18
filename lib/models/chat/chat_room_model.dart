import 'package:tasklink/models/tasks/task_response_user_model.dart';

/// One active task in a chat room (stacked in header).
class ChatRoomActiveTask {
  final String id;
  final String title;
  final String status;

  ChatRoomActiveTask({
    required this.id,
    required this.title,
    required this.status,
  });

  factory ChatRoomActiveTask.fromJson(Map<String, dynamic> json) {
    return ChatRoomActiveTask(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

/// Last message preview in chat room list.
class ChatLastMessageModel {
  final String text;
  final String senderPhone;
  final DateTime? createdAt;

  ChatLastMessageModel({
    required this.text,
    required this.senderPhone,
    this.createdAt,
  });

  factory ChatLastMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatLastMessageModel(
      text: json['text']?.toString() ?? '',
      senderPhone: json['sender']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

/// Chat room (list and detail). One room per user-pair; active_tasks listed for context.
class ChatRoomModel {
  final String id;
  final String? taskId;
  final String? taskTitle;
  final List<ChatRoomActiveTask> activeTasks;
  final TaskResponseUserModel? poster;
  final TaskResponseUserModel? tasker;
  final ChatLastMessageModel? lastMessage;
  final int unreadCount;
  final DateTime? createdAt;

  ChatRoomModel({
    required this.id,
    this.taskId,
    this.taskTitle,
    this.activeTasks = const [],
    this.poster,
    this.tasker,
    this.lastMessage,
    this.unreadCount = 0,
    this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final activeTasksRaw = json['active_tasks'];
    final List<ChatRoomActiveTask> activeTasksList = [];
    if (activeTasksRaw is List) {
      for (final e in activeTasksRaw) {
        if (e is Map<String, dynamic>) {
          activeTasksList.add(ChatRoomActiveTask.fromJson(e));
        } else if (e is Map) {
          activeTasksList.add(ChatRoomActiveTask.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final taskTitle = json['task_title']?.toString();
    return ChatRoomModel(
      id: json['id']?.toString() ?? '',
      taskId: json['task']?.toString(),
      taskTitle: taskTitle,
      activeTasks: activeTasksList,
      poster: json['poster'] != null
          ? TaskResponseUserModel.fromJson(
              Map<String, dynamic>.from(json['poster'] as Map))
          : null,
      tasker: json['tasker'] != null
          ? TaskResponseUserModel.fromJson(
              Map<String, dynamic>.from(json['tasker'] as Map))
          : null,
      lastMessage: json['last_message'] != null
          ? ChatLastMessageModel.fromJson(
              Map<String, dynamic>.from(json['last_message'] as Map))
          : null,
      unreadCount: (json['unread_count'] is int)
          ? json['unread_count'] as int
          : int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Display title: first active task or legacy task_title, or empty.
  String get displayTitle {
    if (activeTasks.isNotEmpty) return activeTasks.first.title;
    return taskTitle ?? '';
  }

  /// Other participant (for current user).
  TaskResponseUserModel? otherParticipant(String currentUserId) {
    if (poster?.id == currentUserId) return tasker;
    return poster;
  }

  /// Whether this room is for the given task (by id).
  bool hasTask(String taskId) {
    if (this.taskId == taskId) return true;
    return activeTasks.any((t) => t.id == taskId);
  }
}
