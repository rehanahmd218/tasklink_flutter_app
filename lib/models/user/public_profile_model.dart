/// Public profile (no phone, email, or personal info).
class PublicProfileModel {
  final String id;
  final String fullName;
  final String? profileImage;
  final double ratingAvg;
  final int reviewsCount;
  final String role;

  PublicProfileModel({
    required this.id,
    required this.fullName,
    this.profileImage,
    required this.ratingAvg,
    required this.reviewsCount,
    required this.role,
  });

  factory PublicProfileModel.fromJson(Map<String, dynamic> json) {
    return PublicProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      ratingAvg: _parseDouble(json['rating_avg']),
      reviewsCount: _parseInt(json['reviews_count']),
      role: json['role'] as String? ?? 'POSTER',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String get displayName => fullName.isNotEmpty ? fullName : 'User';
}
