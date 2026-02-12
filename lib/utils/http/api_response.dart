/// Generic API Response Wrapper
///
/// Handles the standardized response format from Django backend:
/// - Success: {success: true, message: "...", data: {...}}
/// - Error: {success: false, message: "...", errors: {...}}
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  /// Parse JSON response with optional data parser
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    print(json);
    print(dataParser);
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && dataParser != null
          ? dataParser(json['data'])
          : (json['data'] as T?),
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  /// Check if request was successful
  bool get isSuccess => success;

  /// Check if response has field errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  /// Get first error message from errors map
  String get firstError {
    if (errors == null || errors!.isEmpty) return message;

    final firstKey = errors!.keys.first;
    final errorList = errors![firstKey];

    if (errorList is List && errorList.isNotEmpty) {
      return errorList.first.toString();
    }

    return message;
  }

  /// Get all error messages as a single string
  String get allErrors {
    if (errors == null || errors!.isEmpty) return message;

    final errorMessages = <String>[];

    errors!.forEach((field, errorList) {
      if (errorList is List) {
        for (var error in errorList) {
          errorMessages.add(error.toString());
        }
      }
    });

    return errorMessages.isNotEmpty ? errorMessages.join('\n') : message;
  }

  /// Get errors for a specific field
  List<String> getFieldErrors(String field) {
    if (errors == null || !errors!.containsKey(field)) return [];

    final errorList = errors![field];
    if (errorList is List) {
      return errorList.map((e) => e.toString()).toList();
    }

    return [];
  }
}
