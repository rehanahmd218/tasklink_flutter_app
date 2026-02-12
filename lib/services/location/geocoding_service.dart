import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasklink/models/location/location_search_result.dart';

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  static const String _userAgent = 'TaskLink/1.0';

  // Rate limiting: Nominatim requires max 1 request per second
  static DateTime? _lastRequestTime;
  static const Duration _minRequestInterval = Duration(milliseconds: 1000);

  /// Ensure we respect rate limiting
  Future<void> _respectRateLimit() async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        await Future.delayed(_minRequestInterval - timeSinceLastRequest);
      }
    }
    _lastRequestTime = DateTime.now();
  }

  /// Search for locations based on query string
  /// Returns a list of location suggestions
  Future<List<LocationSearchResult>> searchLocation(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    await _respectRateLimit();

    try {
      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': '1',
          'limit': '5',
        },
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => LocationSearchResult.fromJson(item)).toList();
      } else {
        throw Exception('Failed to search location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching location: $e');
    }
  }

  /// Convert address to coordinates (geocoding)
  Future<LocationSearchResult?> geocodeAddress(String address) async {
    final results = await searchLocation(address);
    return results.isNotEmpty ? results.first : null;
  }

  /// Convert coordinates to address (reverse geocoding)
  Future<String> reverseGeocode(double latitude, double longitude) async {
    await _respectRateLimit();

    try {
      final uri = Uri.parse('$_baseUrl/reverse').replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'json',
          'addressdetails': '1',
        },
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? 'Unknown location';
      } else {
        throw Exception('Failed to reverse geocode: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error reverse geocoding: $e');
    }
  }

  /// Get detailed address components from coordinates
  Future<Map<String, dynamic>?> getAddressDetails(
    double latitude,
    double longitude,
  ) async {
    await _respectRateLimit();

    try {
      final uri = Uri.parse('$_baseUrl/reverse').replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'json',
          'addressdetails': '1',
        },
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['address'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
