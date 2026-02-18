import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/authentication/models/user_model.dart';
import 'package:tasklink/models/user/public_profile_model.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/http/api_response.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// User Service
///
/// Handles all user-related API operations
class UserService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Update user profile
  Future<UserModel> updateProfile({
    String? fullName,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    File? profileImage,
    String? role,
  }) async {
    _log.i('Updating user profile');

    try {
      FormData formData = FormData();

      // Add profile fields if provided
      if (fullName != null) {
        formData.fields.add(MapEntry('profile.full_name', fullName));
      }
      if (bio != null) {
        formData.fields.add(MapEntry('profile.bio', bio));
      }
      if (dateOfBirth != null) {
        final formattedDate = dateOfBirth.toIso8601String().split('T').first;
        formData.fields.add(MapEntry('profile.date_of_birth', formattedDate));
      }
      if (gender != null) {
        formData.fields.add(MapEntry('profile.gender', gender));
      }

      // Add role if provided (this is on the user model, not profile)
      if (role != null) {
        formData.fields.add(MapEntry('role', role));
      }

      // Add profile image if provided
      if (profileImage != null) {
        final fileName = profileImage.path.split('/').last;
        formData.files.add(
          MapEntry(
            'profile.profile_image',
            await MultipartFile.fromFile(profileImage.path, filename: fileName),
          ),
        );
      }

      final response = await _dio.put(
        ApiConfig.updateMeEndpoint,
        data: formData,
      );

      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Profile updated successfully');
        return apiResponse.data!;
      } else {
        _log.w('Profile update failed: ${apiResponse.message}');
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Update profile error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Update user role
  Future<UserModel> updateRole(String role) async {
    return updateProfile(role: role);
  }

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConfig.userMeEndpoint);

      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Get current user error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get another user's public profile (id, fullName, profileImage, ratingAvg, reviewsCount, role).
  Future<PublicProfileModel> getPublicProfile(String userId) async {
    _log.i('Fetching public profile for user: $userId');
    try {
      final response = await _dio.get(ApiConfig.userPublicProfileEndpoint(userId));
      final data = response.data;
      Map<String, dynamic>? map;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('data')) {
          map = data['data'] as Map<String, dynamic>?;
        } else {
          map = data;
        }
      }
      if (map != null) {
        return PublicProfileModel.fromJson(map);
      }
      throw ValidationException('Invalid response format', {});
    } on DioException catch (e) {
      _log.e('Get public profile error: ${e.type}');
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw NetworkException('Connection timeout. Please try again.');
    }

    if (e.type == DioExceptionType.connectionError) {
      throw NetworkException(
        'Cannot connect to server. Check your connection.',
      );
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      if (data is Map<String, dynamic>) {
        final message = data['message'] ?? 'An error occurred';
        final errors = data['errors'] as Map<String, dynamic>? ?? {};

        if (statusCode == 400) throw ValidationException(message, errors);
        if (statusCode == 401) throw UnauthorizedException(message);
        if (statusCode == 404) throw NotFoundException(message);
        if (statusCode != null && statusCode >= 500) {
          throw ServerException(message, statusCode: statusCode);
        }
        throw ValidationException(message, errors);
      }
    }

    throw NetworkException('An unexpected error occurred.');
  }
}
