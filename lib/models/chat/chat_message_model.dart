import 'chat_sender_model.dart';
import 'chat_message_media_model.dart';

/// Chat message (REST and WebSocket payload).
class ChatMessageModel {
  final String id;
  final String messageText;
  final ChatSenderModel sender;
  final DateTime createdAt;
  final bool isRead;
  final List<ChatMessageMediaModel> media;

  ChatMessageModel({
    required this.id,
    required this.messageText,
    required this.sender,
    required this.createdAt,
    required this.isRead,
    this.media = const [],
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      messageText: json['message_text'] ?? '',
      sender: ChatSenderModel.fromJson(
        (json['sender'] is Map) ? Map<String, dynamic>.from(json['sender']) : {},
      ),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['is_read'] == true,
      media: (json['media'] is List)
          ? (json['media'] as List)
              .map((e) => ChatMessageMediaModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList()
          : [],
    );
  }
}
