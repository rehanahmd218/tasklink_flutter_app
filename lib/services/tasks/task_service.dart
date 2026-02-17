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

  /// Update an existing task (JSON only).
  /// Use [updateTaskWithMedia] when adding new images on edit.
  Future<TaskModel> updateTask(String taskId, TaskCreateRequest request) async {
    _log.i('Updating task: $taskId');

    try {
      final data = request.toJson();

      final response = await _dio.patch(
        '${ApiConfig.tasksEndpoint}$taskId/',
        data: data,
      );

      return _parseUpdateResponse(response);
    } on DioException catch (e) {
      _log.e('Update task error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Update an existing task with optional new media files and/or media IDs to delete (multipart).
  /// Use when the user added new images and/or removed existing ones in edit mode.
  Future<TaskModel> updateTaskWithMedia(
    String taskId,
    TaskCreateRequest request,
    List<File> newMediaFiles, {
    List<String> deletedMediaIds = const [],
  }) async {
    _log.i(
      'Updating task: $taskId (${newMediaFiles.length} new, ${deletedMediaIds.length} deleted)',
    );

    try {
      final formData = FormData();

      final taskData = request.toJson();
      for (final entry in taskData.entries) {
        if (entry.value != null) {
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }

      for (final id in deletedMediaIds) {
        formData.fields.add(MapEntry('delete_media_ids', id));
      }

      if (newMediaFiles.isNotEmpty) {
        for (final file in newMediaFiles) {
          final fileName = file.path.split(RegExp(r'[/\\]')).last;
          formData.files.add(MapEntry(
            'media_files',
            await MultipartFile.fromFile(file.path, filename: fileName),
          ));
        }
      }

      final response = await _dio.patch(
        '${ApiConfig.tasksEndpoint}$taskId/',
        data: formData,
      );

      return _parseUpdateResponse(response);
    } on DioException catch (e) {
      _log.e('Update task with media error: ${e.type}');
      _handleDioError(e);
    }
  }

  TaskModel _parseUpdateResponse(Response<dynamic> response) {
    final apiResponse = ApiResponse<TaskModel>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => TaskModel.fromJson(data as Map<String, dynamic>),
    );

    if (apiResponse.isSuccess && apiResponse.data != null) {
      _log.i('Task updated successfully: ${apiResponse.data!.id}');
      return apiResponse.data!;
    } else {
      _log.w('Task update failed: ${apiResponse.message}');
      throw ValidationException(
        apiResponse.message,
        apiResponse.errors ?? {},
      );
    }
  }

  /// Cancel a task. POST tasks/{id}/cancel/ (poster only on backend; tasker may get 403)
  Future<void> cancelTask(String taskId) async {
    _log.i('Cancelling task: $taskId');
    try {
      await _dio.post('${ApiConfig.tasksEndpoint}$taskId/cancel/');
      _log.i('Task cancelled successfully');
    } on DioException catch (e) {
      _log.e('Cancel task error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Mark task as completed (tasker only). POST tasks/{id}/mark_completed/
  Future<TaskModel> markTaskCompleted(String taskId) async {
    _log.i('Marking task as completed: $taskId');

    try {
      final response = await _dio.post(
        '${ApiConfig.tasksEndpoint}$taskId/mark_completed/',
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return TaskModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      if (data is Map<String, dynamic>) {
        return TaskModel.fromJson(data);
      }
      throw ValidationException('Invalid response format', {});
    } on DioException catch (e) {
      _log.e('Mark task completed error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    _log.i('Deleting task: $taskId');

    try {
      await _dio.delete('${ApiConfig.tasksEndpoint}$taskId/');
      _log.i('Task deleted successfully');
    } on DioException catch (e) {
      _log.e('Delete task error: ${e.type}');
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
