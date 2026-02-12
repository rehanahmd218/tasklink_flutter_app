/// Task Response User Model
///
/// Represents the simplified user data returned in task API responses.
/// This is different from the full UserModel and only contains the fields
/// that are included in the poster/assigned_tasker objects within task responses.
class TaskResponseUserModel {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String? profileImage;
  final double ratingAvg;
  final int reviewsCount;
  final String role; // 'POSTER', 'TASKER', 'BOTH'

  TaskResponseUserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    this.profileImage,
    required this.ratingAvg,
    required this.reviewsCount,
    required this.role,
  });

  factory TaskResponseUserModel.fromJson(Map<String, dynamic> json) {
    return TaskResponseUserModel(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phone_number'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'],
      ratingAvg: _parseDouble(json['rating_avg']),
      reviewsCount: _parseInt(json['reviews_count']),
      role: json['role'] ?? 'POSTER',
    );
  }

  /// Parse value to double, handles both String and num
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Parse value to int, handles both String and num
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'full_name': fullName,
      if (profileImage != null) 'profile_image': profileImage,
      'rating_avg': ratingAvg,
      'reviews_count': reviewsCount,
      'role': role,
    };
  }

  /// Get display name
  String get displayName => fullName.isNotEmpty ? fullName : phoneNumber;
}
