import 'package:get/get.dart';
import 'package:tasklink/common/widgets/dialogs/status_popup.dart';
import 'package:tasklink/utils/exceptions/api_exceptions.dart';

/// Global error handler for API exceptions
///
/// Extracts title and message from exceptions and shows appropriate popups.
/// Uses the API response format where:
/// - `message` becomes the popup title
/// - First error value becomes the popup message
class ErrorHandler {
  /// Extract title and message from any exception
  ///
  /// Returns a record with `title` and `message` based on exception type.
  /// For ValidationException: message = title, first error = message
  /// For other exceptions: contextual title, exception message = detail
  static ({String title, String message}) extractErrorInfo(Object error) {
    if (error is ValidationException) {
      // API message becomes title, first error value becomes message
      return (
        title: error.message.isNotEmpty ? error.message : 'Validation Error',
        message: error.firstError,
      );
    }

    if (error is NetworkException) {
      return (title: 'Connection Error', message: error.message);
    }

    if (error is ServerException) {
      return (title: 'Server Error', message: error.message);
    }

    if (error is UnauthorizedException) {
      return (title: 'Session Expired', message: error.message);
    }

    if (error is NotFoundException) {
      return (title: 'Not Found', message: error.message);
    }

    // Default for unknown errors
    return (title: 'Error', message: error.toString());
  }

  /// Show error popup using the extracted error info
  ///
  /// Convenience method that extracts error info and shows StatusPopup
  static void showErrorPopup(Object error, {String buttonText = 'OK'}) {
    final info = extractErrorInfo(error);
    StatusPopup.showError(
      title: info.title,
      message: info.message,
      buttonText: buttonText,
      onPressed: () => Get.back(),
    );
  }
}
