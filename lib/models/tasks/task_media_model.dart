/// Task Media Model
///
/// Represents media files attached to tasks
class TaskMediaModel {
  final String id;
  final String task;
  final String uploadedBy;
  final String mediaType; // 'TASK_IMAGE', 'COMPLETION_PROOF'
  final String file;
  final String? caption;
  final DateTime createdAt;

  TaskMediaModel({
    required this.id,
    required this.task,
    required this.uploadedBy,
    required this.mediaType,
    required this.file,
    this.caption,
    required this.createdAt,
  });

  factory TaskMediaModel.fromJson(Map<String, dynamic> json) {
    return TaskMediaModel(
      id: json['id']?.toString() ?? '',
      task: json['task']?.toString() ?? '',
      uploadedBy: json['uploaded_by']?.toString() ?? '',
      mediaType: json['media_type'] ?? 'TASK_IMAGE',
      file: json['file'] ?? '',
      caption: json['caption'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'uploaded_by': uploadedBy,
      'media_type': mediaType,
      'file': file,
      if (caption != null) 'caption': caption,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
