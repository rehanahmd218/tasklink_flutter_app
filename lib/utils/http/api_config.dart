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
  static const String baseUrl = 'http://192.168.100.54:8000/api/v1/';
  // static const String baseUrl = 'http://10.8.25.206:8000/api/v1/';

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

  /// Get task detail by ID
  static String taskDetailEndpoint(String taskId) => 'tasks/$taskId/';

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
