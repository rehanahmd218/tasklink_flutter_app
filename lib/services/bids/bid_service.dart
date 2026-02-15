import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/http/api_response.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// Bid Service
///
/// Handles all bid-related API operations
class BidService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Place a bid on a task
  Future<BidModel> placeBid({
    required String taskId,
    required double amount,
    String? message,
  }) async {
    _log.i('Placing bid on task: $taskId for amount: $amount');

    try {
      final data = {'task': taskId, 'amount': amount, 'message': message};

      final response = await _dio.post(ApiConfig.bidsEndpoint, data: data);

      final apiResponse = ApiResponse<BidModel>.fromJson(
        response.data,
        (data) => BidModel.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Bid placed successfully: ${apiResponse.data!.id}');
        return apiResponse.data!;
      } else {
        _log.w('Bid placement failed: ${apiResponse.message}');
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Place bid error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get all bids for a specific task (Poster view)
  Future<List<BidModel>> getBidsForTask(String taskId) async {
    _log.i('Fetching bids for task: $taskId');

    try {
      final response = await _dio.get(
        ApiConfig.bidsEndpoint,
        queryParameters: {'task': taskId},
      );

      final apiResponse = ApiResponse<List<BidModel>>.fromJson(response.data, (
        data,
      ) {
        if (data is List) {
          return data.map((item) => BidModel.fromJson(item)).toList();
        }
        // Handle pagination if present (though this endpoint might just return a list based on backend)
        if (data is Map<String, dynamic> && data.containsKey('results')) {
          final results = data['results'] as List;
          return results.map((item) => BidModel.fromJson(item)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Fetched ${apiResponse.data!.length} bids for task');
        return apiResponse.data!;
      } else {
        _log.w('Failed to fetch bids for task: ${apiResponse.message}');
        return [];
      }
    } on DioException catch (e) {
      _log.e('Get bids for task error: ${e.type}');
      // Return empty list instead of throwing to avoid blocking UI
      return [];
    }
  }

  /// Get all bids placed by the current user (Tasker view)
  Future<List<BidModel>> getMyBids() async {
    _log.i('Fetching my bids');

    try {
      final response = await _dio.get(
        ApiConfig.bidsEndpoint,
        queryParameters: {
          'filter': 'my_bids',
        }, // Assuming backend supports this filter
      );

      final apiResponse = ApiResponse<List<BidModel>>.fromJson(response.data, (
        data,
      ) {
        if (data is List) {
          return data.map((item) => BidModel.fromJson(item)).toList();
        }
        if (data is Map<String, dynamic> && data.containsKey('results')) {
          final results = data['results'] as List;
          return results.map((item) => BidModel.fromJson(item)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Fetched ${apiResponse.data!.length} my bids');
        return apiResponse.data!;
      } else {
        _log.w('Failed to fetch my bids: ${apiResponse.message}');
        return [];
      }
    } on DioException catch (e) {
      _log.e('Get my bids error: ${e.type}');
      return [];
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
