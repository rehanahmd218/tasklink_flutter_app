/// Global API Configuration
class ApiConfig {
  /// Base URL for the Django REST API
  ///
  /// IMPORTANT: Choose the correct URL based on your setup:
  /// - LDPlayer/BlueStacks: Use your PC's IP (MEmuSwitch adapter)
  /// - Android Studio Emulator: Use 'http://10.0.2.2:8000/api/v1/'
  /// - iOS Simulator: Use 'http://localhost:8000/api/v1/'
  /// - Production: Use your deployed server URL

  /// ### Base url for Emulator
  // static const String baseUrl = 'http://172.30.80.1:8000/api/v1/';

  /// ### Base url for Mobile
  // static const String baseUrl = 'http://192.168.137.247:8000/api/v1/';
  static const String baseUrl = 'http://10.8.24.129:8000/api/v1/';

  // static const String baseUrl = 'https://taskonnect.me/api/v1/';

  /// Timeouts
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;

  /// Authentication endpoints
  static const String registerEndpoint = 'auth/register/';
  static const String loginEndpoint = 'auth/login/';
  static const String refreshEndpoint = 'auth/refresh/';
  static const String sendOtpEndpoint = 'auth/send-otp/';
  static const String verifyOtpEndpoint = 'auth/verify-otp/';
  // static const String logoutEndpoint = 'auth/logout/';

  /// User endpoints
  static const String userMeEndpoint = 'users/me/';
  static const String updateMeEndpoint = 'users/update_me/';
  static const String updateLocationEndpoint = 'users/update_location/';
  static const String changePasswordEndpoint = 'users/change_password/';

  /// Password reset endpoints
  static const String passwordResetSendOtpEndpoint = 'password-reset/send_otp/';
  static const String passwordResetEndpoint = 'password-reset/reset/';

  /// Wallet endpoints
  static const String walletEndpoint = 'wallet/';

  /// Task endpoints
  static const String tasksEndpoint = 'tasks/';
  static const String tasksNearbyEndpoint = 'tasks/nearby/';

  static const String bidsEndpoint = 'bids/';

  /// Reviews endpoints
  static const String reviewsEndpoint = 'reviews/';
  static String reviewsForUserEndpoint(String userId) => 'reviews/?for_user=$userId';

  /// Get task detail by ID
  static String taskDetailEndpoint(String taskId) => 'tasks/$taskId/';

  /// User public profile
  static String userPublicProfileEndpoint(String userId) => 'users/$userId/public/';

  // -------------------------------------------------------------------------
  // Chat endpoints
  // -------------------------------------------------------------------------
  static const String chatRoomsEndpoint = 'chat/rooms/';
  static String chatRoomMessagesEndpoint(String roomId) => 'chat/rooms/$roomId/messages/';
  static String chatRoomUploadMediaEndpoint(String roomId) => 'chat/rooms/$roomId/upload_media/';

  /// WebSocket base URL for chat (replace http with ws; use port 8001 if ASGI runs there)
  static String get wsBaseUrl {
    final uri = Uri.parse(baseUrl);
    final host = uri.host;
    const wsPort = 8001;
    return 'ws://$host:$wsPort';
  }

  static String chatWebSocketUrl(String roomId, String token) =>
      '$wsBaseUrl/ws/chat/$roomId/?token=${Uri.encodeComponent(token)}';

  /// Base URL for media files (no /api/v1/)
  static String get mediaBaseUrl {
    final uri = Uri.parse(baseUrl);
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }

  /// Resolve full URL for a chat media file path (e.g. from message.media[].file).
  static String mediaFileUrl(String filePath) {
    if (filePath.isEmpty) return '';
    if (filePath.startsWith('http://') || filePath.startsWith('https://')) {
      return filePath;
    }
    final path = filePath.startsWith('/') ? filePath : '/media/$filePath';
    return '$mediaBaseUrl$path';
  }

  // ===================================================================
  // PUBLIC ENDPOINTS (No Authentication Required)
  // ===================================================================
  /// List of endpoints that should NOT have auth tokens appended.
  /// Add or remove endpoints here as needed.
  static const List<String> publicEndpoints = [
    // Authentication - these happen before user is logged in
    registerEndpoint,
    loginEndpoint,
    refreshEndpoint,
    // Password Reset - user may not be logged in
    passwordResetSendOtpEndpoint,
    passwordResetEndpoint,
  ];

  /// Check if the given path is a public endpoint (no auth required).
  /// Supports both full URLs and relative paths.
  static bool isPublicEndpoint(String path) {
    // Normalize the path by removing baseUrl if present
    String normalizedPath = path;
    if (path.startsWith(baseUrl)) {
      normalizedPath = path.substring(baseUrl.length);
    }

    // Remove leading slash if present for consistent matching
    if (normalizedPath.startsWith('/')) {
      normalizedPath = normalizedPath.substring(1);
    }

    // Check if the path matches any public endpoint
    return publicEndpoints.any((endpoint) {
      // Also normalize the endpoint for comparison
      String normalizedEndpoint = endpoint;
      if (normalizedEndpoint.startsWith('/')) {
        normalizedEndpoint = normalizedEndpoint.substring(1);
      }
      return normalizedPath == normalizedEndpoint ||
          normalizedPath.startsWith(normalizedEndpoint);
    });
  }
}
