/// Notification model from the API.
/// Backend: id, notification_type, title, body, is_read, related_task_id, related_bid_id, related_message_id, related_chat_room_id, created_at
class NotificationModel {
  final String id;
  final String notificationType;
  final String title;
  final String body;
  final bool isRead;
  final String? relatedTaskId;
  final String? relatedBidId;
  final String? relatedMessageId;
  final String? relatedChatRoomId;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.body,
    required this.isRead,
    this.relatedTaskId,
    this.relatedBidId,
    this.relatedMessageId,
    this.relatedChatRoomId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      notificationType: json['notification_type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isRead: json['is_read'] == true,
      relatedTaskId: json['related_task_id']?.toString(),
      relatedBidId: json['related_bid_id']?.toString(),
      relatedMessageId: json['related_message_id']?.toString(),
      relatedChatRoomId: json['related_chat_room_id']?.toString(),
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// Short time ago string for UI (e.g. "5m ago")
  String get timeAgo {
    if (createdAt.isEmpty) return '';
    final dt = DateTime.tryParse(createdAt);
    if (dt == null) return createdAt;
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
