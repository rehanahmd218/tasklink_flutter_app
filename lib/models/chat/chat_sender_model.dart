/// Sender info in chat messages (REST and WebSocket).
class ChatSenderModel {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String? profileImage;

  ChatSenderModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    this.profileImage,
  });

  factory ChatSenderModel.fromJson(Map<String, dynamic> json) {
    return ChatSenderModel(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phone_number'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'],
    );
  }

  String get displayName => fullName.isNotEmpty ? fullName : phoneNumber;
}
