import 'user_profile_model.dart';

/// User Model
///
/// Represents the complete user data from the API.
class UserModel {
  final String id;
  final String phoneNumber;
  final String email;
  bool isPhoneVerified;
  bool isEmailVerified;
  final String role; // 'POSTER', 'TASKER', 'BOTH'
  final double ratingAvg;
  final int reviewsCount;
  final int totalTasksPosted;
  final int totalTasksCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserProfileModel? profile;
  final bool? isActive;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.role,
    required this.ratingAvg,
    required this.reviewsCount,
    required this.totalTasksPosted,
    required this.totalTasksCompleted,
    required this.createdAt,
    this.isActive,
    this.updatedAt,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      isPhoneVerified: json['is_phone_verified'] ?? false,
      isEmailVerified: json['is_email_verified'] ?? false,
      role: json['role'] ?? 'POSTER',
      ratingAvg: _parseDouble(json['rating_avg']),
      reviewsCount: _parseInt(json['reviews_count']),
      totalTasksPosted: _parseInt(json['total_tasks_posted']),
      totalTasksCompleted: _parseInt(json['total_tasks_completed']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      profile: json['profile'] != null
          ? UserProfileModel.fromJson(json['profile'])
          : null,
      isActive: json['is_active'] ?? false,
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
      'email': email,
      'is_phone_verified': isPhoneVerified,
      'is_email_verified': isEmailVerified,
      'role': role,
      'rating_avg': ratingAvg,
      'reviews_count': reviewsCount,
      'total_tasks_posted': totalTasksPosted,
      'total_tasks_completed': totalTasksCompleted,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (profile != null) 'profile': profile!.toJson(),
    };
  }

  /// Check if user needs phone verification
  bool get needsPhoneVerification => !isPhoneVerified;

  /// Check if user needs email verification
  bool get needsEmailVerification => !isEmailVerified;

  /// Get display name (full name from profile or email)
  String get displayName => profile?.fullName ?? email.split('@').first;

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    String? role,
    double? ratingAvg,
    int? reviewsCount,
    int? totalTasksPosted,
    int? totalTasksCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserProfileModel? profile,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      totalTasksPosted: totalTasksPosted ?? this.totalTasksPosted,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profile: profile ?? this.profile,
    );
  }
}
