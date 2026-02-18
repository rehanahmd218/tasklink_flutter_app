/// Review model from the API.
/// Maps to backend ReviewSerializer: id, task_title, reviewer, reviewee, reviewee_role, rating, comment, created_at.
class ReviewModel {
  final String id;
  final String? taskTitle;
  final int rating;
  final String comment;
  final String createdAt; // ISO string from API
  final String? revieweeRole; // 'poster' | 'tasker'
  final ReviewUserRef reviewer;
  final ReviewUserRef reviewee;

  ReviewModel({
    required this.id,
    this.taskTitle,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.revieweeRole,
    required this.reviewer,
    required this.reviewee,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      taskTitle: json['task_title'] as String?,
      rating: _parseInt(json['rating']) ?? 1, // 1-5
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      revieweeRole: json['reviewee_role'] as String?,
      reviewer: ReviewUserRef.fromJson(
        json['reviewer'] as Map<String, dynamic>? ?? {},
      ),
      reviewee: ReviewUserRef.fromJson(
        json['reviewee'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Display date for UI (e.g. "Oct 24, 2023")
  String get formattedDate {
    if (createdAt.isEmpty) return '';
    final dt = DateTime.tryParse(createdAt);
    if (dt == null) return createdAt;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class ReviewUserRef {
  final String id;
  final String fullName;
  final String? profileImage;

  ReviewUserRef({
    required this.id,
    required this.fullName,
    this.profileImage,
  });

  factory ReviewUserRef.fromJson(Map<String, dynamic> json) {
    return ReviewUserRef(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
    );
  }
}
