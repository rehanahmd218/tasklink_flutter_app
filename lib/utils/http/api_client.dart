import 'package:dio/dio.dart';
import 'api_config.dart';
import 'api_interceptor.dart';

/// Singleton API Client using Dio
class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(seconds: ApiConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(ApiInterceptor());
  }

  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  static void reset() {
    _instance = null;
  }
}
