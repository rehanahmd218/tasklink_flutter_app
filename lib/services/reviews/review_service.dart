import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/models/reviews/review_model.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// Service for review API: create review, list my reviews received, list reviews for a user.
class ReviewService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Create a review for a task. Task must be CONFIRMED; caller must be poster or tasker.
  Future<ReviewModel> createReview({
    required String taskId,
    required int rating,
    String? comment,
  }) async {
    _log.i('Creating review for task: $taskId, rating: $rating');
    try {
      final response = await _dio.post(
        ApiConfig.reviewsEndpoint,
        data: {
          'task': taskId,
          'rating': rating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
      );
      final data = response.data;
      Map<String, dynamic>? reviewMap;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('data')) {
          reviewMap = data['data'] as Map<String, dynamic>?;
        } else {
          reviewMap = data;
        }
      }
      if (reviewMap != null) {
        return ReviewModel.fromJson(reviewMap);
      }
      throw ValidationException('Invalid response format', {});
    } on DioException catch (e) {
      _log.e('Create review error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// List reviews received by the current user.
  Future<List<ReviewModel>> getMyReviewsReceived() async {
    _log.i('Fetching my reviews received');
    return _fetchReviewsList(ApiConfig.reviewsEndpoint);
  }

  /// List reviews received by the given user (for public profile).
  Future<List<ReviewModel>> getReviewsForUser(String userId) async {
    _log.i('Fetching reviews for user: $userId');
    return _fetchReviewsList(ApiConfig.reviewsForUserEndpoint(userId));
  }

  Future<List<ReviewModel>> _fetchReviewsList(String path) async {
    try {
      final response = await _dio.get(path);
      final data = response.data;
      List<dynamic>? list;
      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey('data') && data['data'] is List) {
          list = data['data'] as List;
        } else if (data.containsKey('results')) {
          list = data['results'] as List?;
        }
      }
      if (list != null) {
        return list
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _log.e('Fetch reviews error: ${e.type}');
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
