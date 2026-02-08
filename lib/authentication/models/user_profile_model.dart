/// User Profile Model
///
/// Represents the nested profile data within a user.
class UserProfileModel {
  final String fullName;
  final String? profileImage;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? gender; // 'M', 'F', 'O', 'N'

  UserProfileModel({
    required this.fullName,
    this.profileImage,
    this.bio,
    this.dateOfBirth,
    this.gender,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'],
      bio: json['bio'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      if (profileImage != null) 'profile_image': profileImage,
      if (bio != null) 'bio': bio,
      if (dateOfBirth != null)
        'date_of_birth': dateOfBirth!.toIso8601String().split('T').first,
      if (gender != null) 'gender': gender,
    };
  }

  UserProfileModel copyWith({
    String? fullName,
    String? profileImage,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}
