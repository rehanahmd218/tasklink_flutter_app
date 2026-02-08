import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage helper for JWT tokens and user data
///
/// Uses in-memory caching to avoid reading from storage on every request.
class StorageHelper {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // In-memory cache for tokens (avoids repeated storage reads)
  static String? _cachedAccessToken;
  static String? _cachedRefreshToken;
  static String? _cachedUserId;

  /// Save both tokens and cache them
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    // Update cache
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
  }

  /// Save only access token (used after token refresh)
  static Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    _cachedAccessToken = accessToken;
  }

  /// Get access token (from cache or storage)
  static Future<String?> getAccessToken() async {
    if (_cachedAccessToken != null) {
      return _cachedAccessToken;
    }
    _cachedAccessToken = await _storage.read(key: _accessTokenKey);
    return _cachedAccessToken;
  }

  /// Get refresh token (from cache or storage)
  static Future<String?> getRefreshToken() async {
    if (_cachedRefreshToken != null) {
      return _cachedRefreshToken;
    }
    _cachedRefreshToken = await _storage.read(key: _refreshTokenKey);
    return _cachedRefreshToken;
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
    _cachedUserId = userId;
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    if (_cachedUserId != null) {
      return _cachedUserId;
    }
    _cachedUserId = await _storage.read(key: _userIdKey);
    return _cachedUserId;
  }

  /// Clear all tokens and cache (used on logout)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    // Clear cache
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _cachedUserId = null;
  }

  /// Check if user has valid tokens
  static Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Initialize cache from storage (call on app start)
  static Future<void> initCache() async {
    _cachedAccessToken = await _storage.read(key: _accessTokenKey);
    _cachedRefreshToken = await _storage.read(key: _refreshTokenKey);
    _cachedUserId = await _storage.read(key: _userIdKey);
  }
}
