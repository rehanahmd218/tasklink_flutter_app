/// Media attachment on a chat message.
class ChatMessageMediaModel {
  final String id;
  final String mediaType; // IMAGE, VIDEO, AUDIO, FILE
  final String file; // URL or path
  final int fileSize;
  final String fileName;

  ChatMessageMediaModel({
    required this.id,
    required this.mediaType,
    required this.file,
    required this.fileSize,
    required this.fileName,
  });

  factory ChatMessageMediaModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageMediaModel(
      id: json['id']?.toString() ?? '',
      mediaType: json['media_type'] ?? 'FILE',
      file: json['file']?.toString() ?? '',
      fileSize: (json['file_size'] is int)
          ? json['file_size'] as int
          : int.tryParse(json['file_size']?.toString() ?? '0') ?? 0,
      fileName: json['file_name'] ?? '',
    );
  }

  bool get isImage => mediaType == 'IMAGE';
}
