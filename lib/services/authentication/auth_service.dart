import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/authentication/models/auth_response_model.dart';
import 'package:tasklink/authentication/models/user_model.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/http/api_response.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';
import 'package:tasklink/utils/local_storage/storage_helper.dart';

/// Authentication Service
class AuthService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Register a new user
  Future<AuthResponseModel> register({
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirm,
    required String fullName,
    String role = 'POSTER',
  }) async {
    _log.i('Registering user: $email');

    try {
      final response = await _dio.post(
        ApiConfig.registerEndpoint,
        data: {
          'phone_number': phoneNumber,
          'email': email,
          'password': password,
          'password_confirm': passwordConfirm,
          'role': role,
          'profile': {'full_name': fullName},
        },
      );

      final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
        response.data,
        (data) => AuthResponseModel.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Registration successful for: $email');

        await StorageHelper.saveTokens(
          accessToken: apiResponse.data!.tokens.access,
          refreshToken: apiResponse.data!.tokens.refresh,
        );
        await StorageHelper.saveUserId(apiResponse.data!.user.id);

        return apiResponse.data!;
      } else {
        _log.w('Registration failed: ${apiResponse.message}');
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Registration error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Login user with phone/email and password
  Future<AuthResponseModel> login({
    required String username, // Can be phone or email
    required String password,
  }) async {
    _log.i('Logging in user: $username');
    _log.i('Password: $password');
    try {
      final response = await _dio.post(
        ApiConfig.loginEndpoint,
        data: {'username': username, 'password': password},
      );

      final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
        response.data,
        (data) => AuthResponseModel.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Login successful for: $username');

        await StorageHelper.saveTokens(
          accessToken: apiResponse.data!.tokens.access,
          refreshToken: apiResponse.data!.tokens.refresh,
        );
        await StorageHelper.saveUserId(apiResponse.data!.user.id);

        return apiResponse.data!;
      } else {
        _log.w('Login failed: ${apiResponse.message}');
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Login error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Logout user
  Future<void> logout() async {
    // NOTE: Backend logout (token blacklisting) is optional.
    // Since the endpoint might not exist yet, we just clear local tokens.
    // If you implement it later, uncomment the following:
    /*
    try {
      await _dio.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      _log.w('Backend logout failed: $e');
    }
    */

    await StorageHelper.clearTokens();
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

  /// Send OTP
  Future<void> sendOtp({required String type}) async {
    try {
      await _dio.post(ApiConfig.sendOtpEndpoint, data: {'type': type});
    } on DioException catch (e) {
      _log.e('Send OTP error: ${e.type}');
      throw _handleDioError(e);
    }
  }

  /// Verify OTP
  Future<void> verifyOtp({required String type, required String otp}) async {
    try {
      await _dio.post(
        ApiConfig.verifyOtpEndpoint,
        data: {'type': type, 'otp': otp},
      );
    } on DioException catch (e) {
      _log.e('Verify OTP error: ${e.type}');
      throw _handleDioError(e);
    }
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
      throw _handleDioError(e);
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({String? fullName, String? email}) async {
    try {
      final data = <String, dynamic>{};
      if (fullName != null) data['full_name'] = fullName;
      if (email != null) data['email'] = email;

      final response = await _dio.patch(ApiConfig.updateMeEndpoint, data: data);

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
      _log.e('Update profile error: ${e.type}');
      throw _handleDioError(e);
    }
  }

  /// Request OTP for Password Reset
  Future<void> sendPasswordResetOtp({required String identifier}) async {
    try {
      await _dio.post(
        ApiConfig.passwordResetSendOtpEndpoint,
        data: {'identifier': identifier},
      );
    } on DioException catch (e) {
      _log.e('Send Password Reset OTP error: ${e.type}');
      throw _handleDioError(e);
    }
  }

  /// Reset Password with OTP
  Future<void> resetPassword({
    required String identifier,
    required String otp,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    try {
      await _dio.post(
        ApiConfig.passwordResetEndpoint,
        data: {
          'identifier': identifier,
          'otp': otp,
          'new_password': newPassword,
          'new_password_confirm': newPasswordConfirm,
        },
      );
    } on DioException catch (e) {
      _log.e('Reset Password error: ${e.type}');
      throw _handleDioError(e);
    }
  }
}
