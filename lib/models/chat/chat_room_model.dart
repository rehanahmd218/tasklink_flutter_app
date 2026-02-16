import 'package:tasklink/models/tasks/task_response_user_model.dart';

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

/// Chat room (list and detail).
class ChatRoomModel {
  final String id;
  final String taskId;
  final String taskTitle;
  final TaskResponseUserModel? poster;
  final TaskResponseUserModel? tasker;
  final ChatLastMessageModel? lastMessage;
  final int unreadCount;
  final DateTime? createdAt;

  ChatRoomModel({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    this.poster,
    this.tasker,
    this.lastMessage,
    this.unreadCount = 0,
    this.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id']?.toString() ?? '',
      taskId: json['task']?.toString() ?? '',
      taskTitle: json['task_title'] ?? '',
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

  /// Other participant (for current user).
  TaskResponseUserModel? otherParticipant(String currentUserId) {
    if (poster?.id == currentUserId) return tasker;
    return poster;
  }
}
