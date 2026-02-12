import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/models/tasks/task_create_request.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/http/api_response.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// Task Service
///
/// Handles all task-related API operations
class TaskService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Create a new task with optional media files
  Future<TaskModel> createTask(
    TaskCreateRequest request,
    List<File> mediaFiles,
  ) async {
    _log.i('Creating task: ${request.title}');

    try {
      // Build FormData with task fields and media files
      FormData formData = FormData();

      // Add task fields
      final taskData = request.toJson();
      taskData.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add media files if provided
      if (mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          final fileName = file.path.split('/').last;
          formData.files.add(
            MapEntry(
              'media_files',
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        }
        _log.i('Adding ${mediaFiles.length} media files to task');
      }

      final response = await _dio.post(ApiConfig.tasksEndpoint, data: formData);

      final apiResponse = ApiResponse<TaskModel>.fromJson(
        response.data,
        (data) => TaskModel.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Task created successfully: ${apiResponse.data!.id}');
        return apiResponse.data!;
      } else {
        _log.w('Task creation failed: ${apiResponse.message}');
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Create task error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get tasks posted by the current user (Poster role)
  /// Optional status parameter to filter by task status
  Future<List<TaskModel>> getMyPostedTasks({String? status}) async {
    _log.i(
      'Fetching my posted tasks${status != null ? ' with status: $status' : ''}',
    );

    try {
      final queryParams = <String, dynamic>{'filter': 'my_tasks'};

      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _dio.get(
        ApiConfig.tasksEndpoint,
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<List<TaskModel>>.fromJson(response.data, (
        data,
      ) {
        // Handle paginated response: data contains {count, next, previous, results}
        if (data is Map<String, dynamic> && data.containsKey('results')) {
          final results = data['results'] as List;
          return results.map((item) => TaskModel.fromJson(item)).toList();
        }
        // Fallback for non-paginated response
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Fetched ${apiResponse.data!.length} posted tasks');
        return apiResponse.data!;
      } else {
        _log.w('Failed to fetch posted tasks: ${apiResponse.message}');
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Get my posted tasks error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get tasks assigned to the current user (Tasker role)
  /// Optional status parameter to filter by task status
  Future<List<TaskModel>> getTasksAssignedToMe({String? status}) async {
    _log.i(
      'Fetching tasks assigned to me${status != null ? ' with status: $status' : ''}',
    );

    try {
      final queryParams = <String, dynamic>{'filter': 'assigned_to_me'};

      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _dio.get(
        ApiConfig.tasksEndpoint,
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<List<TaskModel>>.fromJson(response.data, (
        data,
      ) {
        // Handle paginated response: data contains {count, next, previous, results}
        if (data is Map<String, dynamic> && data.containsKey('results')) {
          final results = data['results'] as List;
          return results.map((item) => TaskModel.fromJson(item)).toList();
        }
        // Fallback for non-paginated response
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Fetched ${apiResponse.data!.length} assigned tasks');
        return apiResponse.data!;
      } else {
        _log.w('Failed to fetch assigned tasks: ${apiResponse.message}');
        throw ValidationException(
          apiResponse.message,
          apiResponse.errors ?? {},
        );
      }
    } on DioException catch (e) {
      _log.e('Get tasks assigned to me error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Get nearby tasks
  Future<List<TaskModel>> getNearbyTasks({
    required double lat,
    required double lng,
    int? radius,
  }) async {
    _log.i('Fetching nearby tasks at ($lat, $lng) radius: $radius');

    try {
      final queryParams = <String, dynamic>{
        'lat': lat.toString(),
        'lng': lng.toString(),
      };

      if (radius != null) {
        queryParams['tasker_radius'] = radius.toString();
      }

      final response = await _dio.get(
        '${ApiConfig.tasksEndpoint}nearby/',
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<List<TaskModel>>.fromJson(response.data, (
        data,
      ) {
        if (data is Map<String, dynamic> && data.containsKey('results')) {
          final results = data['results'] as List;
          return results.map((item) => TaskModel.fromJson(item)).toList();
        }
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Fetched ${apiResponse.data!.length} nearby tasks');
        return apiResponse.data!;
      } else {
        _log.w('Failed to fetch nearby tasks: ${apiResponse.message}');
        return [];
      }
    } on DioException catch (e) {
      _log.e('Get nearby tasks error: ${e.type}');
      return [];
    }
  }

  /// Get a single task by ID
  Future<TaskModel> getTaskById(String taskId) async {
    _log.i('Fetching task details for ID: $taskId');

    try {
      final response = await _dio.get(ApiConfig.taskDetailEndpoint(taskId));

      // The response is the task object directly, not wrapped in ApiResponse
      final taskData = response.data;

      if (taskData is Map<String, dynamic>) {
        final task = TaskModel.fromJson(taskData);
        _log.i('Successfully fetched task: ${task.title}');
        return task;
      } else {
        _log.w('Invalid task data format');
        throw ValidationException('Invalid task data format', {});
      }
    } on DioException catch (e) {
      _log.e('Get task by ID error: ${e.type}');
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
