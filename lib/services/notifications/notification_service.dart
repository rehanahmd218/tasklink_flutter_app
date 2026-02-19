import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/models/notifications/notification_model.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// Service for notifications API: list unread, unread count, mark read, mark all read.
class NotificationService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Fetch unread notifications only (default backend behavior when no query param).
  Future<List<NotificationModel>> getUnreadNotifications() async {
    _log.i('Fetching unread notifications');
    try {
      final response = await _dio.get(
        ApiConfig.notificationsEndpoint,
        queryParameters: {'is_read': 'false'},
      );
      final data = response.data;
      List<dynamic>? list;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('data')) {
          final d = data['data'];
          if (d is List) {
            list = d;
          } else if (d is Map<String, dynamic> && d.containsKey('results')) {
            list = d['results'] as List?;
          }
        } else if (data.containsKey('results')) {
          list = data['results'] as List?;
        }
      } else if (data is List) {
        list = data;
      }
      if (list != null) {
        return list
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _log.e('Fetch notifications error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get unread count for badge.
  Future<int> getUnreadCount() async {
    _log.i('Fetching unread count');
    try {
      final response = await _dio.get(
        ApiConfig.notificationsUnreadCountEndpoint,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final d = data['data'];
        if (d is Map<String, dynamic> && d.containsKey('count')) {
          final c = d['count'];
          if (c is int) return c;
          if (c is num) return c.toInt();
        }
      }
      return 0;
    } on DioException catch (e) {
      _log.e('Unread count error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Mark a single notification as read (dismiss). It will disappear from unread list.
  Future<void> markAsRead(String notificationId) async {
    _log.i('Mark notification as read: $notificationId');
    try {
      await _dio.patch(ApiConfig.notificationMarkReadEndpoint(notificationId));
    } on DioException catch (e) {
      _log.e('Mark read error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    _log.i('Mark all notifications as read');
    try {
      await _dio.post(ApiConfig.notificationsMarkAllReadEndpoint);
    } on DioException catch (e) {
      _log.e('Mark all read error: ${e.type}');
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
