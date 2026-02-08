/// Custom API Exceptions
///
/// These exceptions provide structured error handling for different API scenarios.

/// Server-side error (5xx status codes)
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

/// Network connection error (no internet, timeout, etc.)
class NetworkException implements Exception {
  final String message;

  NetworkException([
    this.message = 'Network error occurred. Please check your connection.',
  ]);

  @override
  String toString() => 'NetworkException: $message';
}

/// Validation error (400 status with field errors)
class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic> errors;

  ValidationException(this.message, this.errors);

  /// Get first error from the errors map
  String get firstError {
    if (errors.isEmpty) return message;

    final firstKey = errors.keys.first;
    final errorList = errors[firstKey];

    if (errorList is List && errorList.isNotEmpty) {
      return errorList.first.toString();
    }

    return message;
  }

  @override
  String toString() => 'ValidationException: $message';
}

/// Authentication error (401 status, invalid/expired token)
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'Unauthorized. Please login again.']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Resource not found (404 status)
class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Resource not found.']);

  @override
  String toString() => 'NotFoundException: $message';
}
