import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart' show Logger, PrettyPrinter;
import 'package:tasklink/models/chat/chat_room_model.dart';
import 'package:tasklink/models/chat/chat_message_model.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/http/api_response.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// Chat REST API: rooms (sorted by latest message), messages, media upload.
class ChatService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Fetch all chat rooms for current user (backend returns sorted by latest message first).
  Future<List<ChatRoomModel>> getMyRooms() async {
    _log.i('Fetching chat rooms');
    try {
      final response = await _dio.get(ApiConfig.chatRoomsEndpoint);
      final apiResponse = ApiResponse<List<ChatRoomModel>>.fromJson(
        response.data,
        (data) {
          final list = _extractList(data);
          return list
              .map(
                (e) =>
                    ChatRoomModel.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList();
        },
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Fetched ${apiResponse.data!.length} chat rooms');
        return apiResponse.data!;
      }
      _log.w('Fetch rooms failed: ${apiResponse.message}');
      throw ValidationException(apiResponse.message, apiResponse.errors ?? {});
    } on DioException catch (e) {
      _log.e('Get rooms error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Fetch messages for a room.
  Future<List<ChatMessageModel>> getMessages(String roomId) async {
    _log.i('Fetching messages for room: $roomId');
    try {
      final response = await _dio.get(
        ApiConfig.chatRoomMessagesEndpoint(roomId),
      );
      final apiResponse = ApiResponse<List<ChatMessageModel>>.fromJson(
        response.data,
        (data) {
          final list = _extractList(data);
          return list
              .map(
                (e) => ChatMessageModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        },
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        _log.i('Fetched ${apiResponse.data!.length} messages');
        return apiResponse.data!;
      }
      _log.w('Fetch messages failed: ${apiResponse.message}');
      throw ValidationException(apiResponse.message, apiResponse.errors ?? {});
    } on DioException catch (e) {
      _log.e('Get messages error: ${e.type}');
      _handleDioError(e);
    }
  }

  /// Upload a file for attaching to a message. Returns pending media id for WebSocket send.
  /// Use the returned id in WebSocket: {"message": "text", "media_ids": [id]}.
  Future<String> uploadMessageMedia(
    String roomId,
    File file, {
    String mediaType = 'IMAGE',
  }) async {
    _log.i('Uploading media to room: $roomId');
    try {
      final name = file.path.split(RegExp(r'[/\\]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: name),
        'media_type': mediaType,
      });
      final response = await _dio.post(
        ApiConfig.chatRoomUploadMediaEndpoint(roomId),
        data: formData,
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        final id = apiResponse.data!['id']?.toString();
        if (id != null && id.isNotEmpty) {
          _log.i('Media uploaded: $id');
          return id;
        }
      }
      _log.w('Upload media failed: ${apiResponse.message}');
      throw ValidationException(
        apiResponse.message,
        apiResponse.errors ?? {},
      );
    } on DioException catch (e) {
      _log.e('Upload media error: ${e.type}');
      _handleDioError(e);
    }
  }

  static List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey('results')) {
      final r = data['results'];
      return r is List ? r : <dynamic>[];
    }
    return <dynamic>[];
  }

  Never _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode ?? 0;
      final data = e.response!.data;
      final message = data is Map
          ? (data['message'] ?? data['detail'] ?? '').toString()
          : '';
      final errors = data is Map<String, dynamic>
          ? (data['errors'] as Map<String, dynamic>?) ?? {}
          : <String, dynamic>{};
      if (statusCode == 401) throw UnauthorizedException(message);
      if (statusCode == 403) {
        throw ValidationException(
          message.isNotEmpty ? message : 'Forbidden',
          errors,
        );
      }
      if (statusCode == 404) throw NotFoundException(message);
      if (statusCode >= 500) {
        throw ServerException(message, statusCode: statusCode);
      }
      throw ValidationException(
        message.isNotEmpty ? message : 'Request failed',
        errors,
      );
    }
    throw NetworkException(e.message ?? 'Network error');
  }
}
