import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/utils/http/api_client.dart';
import 'package:tasklink/utils/http/api_config.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// Location Service
///
/// Handles sending location updates to the backend.
class LocationService {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final Dio _dio = ApiClient.instance.dio;

  /// Send user's location to backend
  ///
  /// [latitude] and [longitude] are the GPS coordinates.
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    _log.i('Updating location: $latitude, $longitude');

    try {
      final response = await _dio.post(
        ApiConfig.updateLocationEndpoint,
        data: {'latitude': latitude, 'longitude': longitude},
      );

      if (response.statusCode == 200) {
        _log.i('Location updated successfully');
      }
    } on DioException catch (e) {
      _log.e('Location update failed: ${e.type}');
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      throw NetworkException('Cannot connect to server.');
    }

    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        throw ServerException(data['message'] ?? 'Failed to update location');
      }
    }

    throw NetworkException('Failed to update location.');
  }
}
