import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../local_storage/storage_helper.dart';
import 'api_config.dart';

/// JWT API Interceptor
class ApiInterceptor extends Interceptor {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _log.i('→ ${options.method} ${options.path}');

    // Only attach token for protected endpoints (not public)
    if (!ApiConfig.isPublicEndpoint(options.path)) {
      final token = await StorageHelper.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        _log.d('  ✓ Auth token attached');
      } else {
        _log.w('  ⚠ No auth token available for protected endpoint');
      }
    } else {
      _log.d('  ⊘ Public endpoint, skipping auth token');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.i('← ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    _log.e('✗ ${err.type}: ${err.requestOptions.path}');
    if (err.response != null) {
      _log.e('  Status: ${err.response!.statusCode}');
    }

    if (err.response?.statusCode == 401) {
      _log.w('  Token expired, refreshing...');
      final refreshed = await _refreshToken();

      if (refreshed) {
        _log.i('  Token refreshed, retrying...');
        try {
          final response = await _retry(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return super.onError(err, handler);
        }
      }
    }

    super.onError(err, handler);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await StorageHelper.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await dio.post(
        ApiConfig.refreshEndpoint,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        await StorageHelper.saveAccessToken(response.data['data']['access']);
        return true;
      }
      return false;
    } catch (e) {
      await StorageHelper.clearTokens();
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await StorageHelper.getAccessToken();
    return Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
      ),
    );
  }
}
