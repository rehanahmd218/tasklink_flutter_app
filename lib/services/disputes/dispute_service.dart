import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/models/disputes/dispute_model.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

class DisputeService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Get reason choices for dispute creation. [raiser] is 'poster' or 'tasker'.
  Future<List<String>> getReasonChoices({String raiser = 'poster'}) async {
    _log.i('Fetching dispute reason choices for raiser: $raiser');
    try {
      final response = await _dio.get(
        ApiConfig.disputeReasonChoicesEndpoint(raiser: raiser),
      );
      final data = response.data;
      List<String> list = [];
      if (data is Map<String, dynamic>) {
        final d = data['data'];
        if (d is List) {
          for (final e in d) {
            if (e != null) list.add(e.toString());
          }
        }
      }
      return list;
    } on DioException catch (e) {
      _log.e('Get reason choices error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Create a dispute for a task.
  Future<DisputeModel> createDispute({
    required String taskId,
    required String reason,
  }) async {
    _log.i('Creating dispute for task: $taskId');
    try {
      final response = await _dio.post(
        ApiConfig.disputesEndpoint,
        data: {'task': taskId, 'reason': reason},
      );
      final data = response.data;
      Map<String, dynamic>? disputeMap;
      if (data is Map<String, dynamic>) {
        disputeMap = data['data'] as Map<String, dynamic>? ?? data;
      }
      if (disputeMap != null) {
        return DisputeModel.fromJson(disputeMap);
      }
      throw ValidationException('Invalid dispute response', {});
    } on DioException catch (e) {
      _log.e('Create dispute error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get dispute by ID.
  Future<DisputeModel> getDisputeById(String disputeId) async {
    _log.i('Fetching dispute: $disputeId');
    try {
      final response = await _dio.get(ApiConfig.disputeDetailEndpoint(disputeId));
      final data = response.data;
      Map<String, dynamic>? disputeMap;
      if (data is Map<String, dynamic>) {
        disputeMap = data['data'] as Map<String, dynamic>? ?? data;
      }
      if (disputeMap != null) {
        return DisputeModel.fromJson(disputeMap);
      }
      throw NotFoundException('Dispute not found');
    } on DioException catch (e) {
      _log.e('Get dispute error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Upload a media file for a dispute (max 3 per dispute). Call after creating the dispute.
  Future<void> uploadDisputeMedia(String disputeId, File file) async {
    _log.i('Uploading dispute media for dispute: $disputeId');
    try {
      final formData = FormData.fromMap({
        'dispute': disputeId,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split(RegExp(r'[/\\]')).last,
        ),
      });
      await _dio.post(
        ApiConfig.disputeMediaEndpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
    } on DioException catch (e) {
      _log.e('Upload dispute media error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get dispute for a task (if any). Returns null if no dispute.
  Future<DisputeModel?> getDisputeByTask(String taskId) async {
    _log.i('Fetching dispute for task: $taskId');
    try {
      final response = await _dio.get(
        ApiConfig.disputesEndpoint,
        queryParameters: {'task': taskId},
      );
      final data = response.data;
      List<dynamic>? list;
      if (data is Map<String, dynamic>) {
        final d = data['data'];
        if (d is List) {
          list = d;
        } else if (d is Map<String, dynamic> && d.containsKey('results')) {
          list = d['results'] as List?;
        }
      } else if (data is List) {
        list = data;
      }
      if (list != null && list.isNotEmpty) {
        return DisputeModel.fromJson(list.first as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      _log.e('Get dispute by task error: ${e.type}');
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
