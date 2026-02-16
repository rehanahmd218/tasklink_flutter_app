import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart' show Logger, PrettyPrinter;
import 'package:tasklink/models/chat/chat_message_model.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/local_storage/storage_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Connection status for chat WebSocket.
enum ChatConnectionStatus {
  connecting,
  connected,
  disconnected,
  error,
}

/// WebSocket client for a single chat room: connect with token, send/receive, reconnect with backoff.
class ChatWebSocketService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  WebSocketChannel? _channel;
  String? _roomId;
  StreamSubscription? _subscription;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const List<int> _backoffSeconds = [1, 2, 3, 5, 8];

  final StreamController<ChatMessageModel> _messageController =
      StreamController<ChatMessageModel>.broadcast();
  final StreamController<ChatConnectionStatus> _statusController =
      StreamController<ChatConnectionStatus>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  Stream<ChatMessageModel> get messageStream => _messageController.stream;
  Stream<ChatConnectionStatus> get statusStream => _statusController.stream;
  Stream<String> get errorStream => _errorController.stream;

  ChatConnectionStatus _status = ChatConnectionStatus.disconnected;
  ChatConnectionStatus get status => _status;

  bool get isConnected => _status == ChatConnectionStatus.connected;

  /// Connect to room. Call with roomId and optional token (if null, reads from StorageHelper).
  Future<void> connect(String roomId, {String? token}) async {
    if (_roomId == roomId && _status == ChatConnectionStatus.connected) {
      return;
    }
    await disconnect();
    _roomId = roomId;
    final accessToken = token ?? await StorageHelper.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      _setStatus(ChatConnectionStatus.error);
      _errorController.add('Not authenticated');
      return;
    }
    final uri = Uri.parse(
      ApiConfig.chatWebSocketUrl(roomId, accessToken),
    );
    _setStatus(ChatConnectionStatus.connecting);
    _log.i('Connecting to chat room: $roomId');
    try {
      _channel = WebSocketChannel.connect(uri);
      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      Future.delayed(const Duration(milliseconds: 400), () {
        if (_channel != null && _status == ChatConnectionStatus.connecting) {
          markConnected();
        }
      });
    } catch (e, st) {
      _log.e('WebSocket connect error: $e', error: e, stackTrace: st);
      _setStatus(ChatConnectionStatus.error);
      _errorController.add(e.toString());
      _scheduleReconnect();
    }
  }

  void _onData(dynamic data) {
    try {
      final map = jsonDecode(data is String ? data : data.toString())
          as Map<String, dynamic>;
      final type = map['type'] as String?;
      if (type == 'message') {
        final msgData = map['data'];
        if (msgData is Map<String, dynamic>) {
          final message = ChatMessageModel.fromJson(msgData);
          _messageController.add(message);
        }
      } else if (map.containsKey('error')) {
        _errorController.add(map['error'].toString());
      }
    } catch (e) {
      _log.w('Parse WebSocket message error: $e');
    }
  }

  void _onError(dynamic error) {
    _log.w('WebSocket error: $error');
    _setStatus(ChatConnectionStatus.error);
    _errorController.add(error.toString());
    _scheduleReconnect();
  }

  void _onDone() {
    _log.i('WebSocket closed');
    _setStatus(ChatConnectionStatus.disconnected);
    if (_reconnectAttempts < _maxReconnectAttempts && _roomId != null) {
      _scheduleReconnect();
    }
  }

  void _setStatus(ChatConnectionStatus s) {
    if (_status == s) return;
    _status = s;
    if (s == ChatConnectionStatus.connected) {
      _reconnectAttempts = 0;
    }
    _statusController.add(s);
  }

  void _scheduleReconnect() {
    if (_roomId == null) return;
    final delay = _reconnectAttempts < _backoffSeconds.length
        ? _backoffSeconds[_reconnectAttempts]
        : _backoffSeconds.last;
    _reconnectAttempts++;
    _log.i('Reconnecting in ${delay}s (attempt $_reconnectAttempts)');
    Future.delayed(Duration(seconds: delay), () {
      if (_roomId != null && _status != ChatConnectionStatus.connected) {
        connect(_roomId!);
      }
    });
  }

  /// Send a text message, optionally with media IDs from upload.
  void sendMessage(String text, {List<String>? mediaIds}) {
    if (_channel == null) return;
    final payload = <String, dynamic>{'message': text};
    if (mediaIds != null && mediaIds.isNotEmpty) {
      payload['media_ids'] = mediaIds;
    }
    try {
      _channel!.sink.add(jsonEncode(payload));
    } catch (e) {
      _log.e('Send message error: $e');
      _errorController.add(e.toString());
    }
  }

  /// Call when WebSocket is accepted (after first message received or after connection ready).
  void markConnected() {
    _setStatus(ChatConnectionStatus.connected);
  }

  Future<void> disconnect() async {
    _reconnectAttempts = _maxReconnectAttempts;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _roomId = null;
    _setStatus(ChatConnectionStatus.disconnected);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _statusController.close();
    _errorController.close();
  }
}
