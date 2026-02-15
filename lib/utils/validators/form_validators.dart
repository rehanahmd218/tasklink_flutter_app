/// Form Validators
///
/// Validation functions for form fields. Returns error message or null if valid.

class FormValidators {
  /// Validate phone number
  /// - Must be exactly 12 digits
  /// - Must start with 92 (Pakistan country code)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces or dashes
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!RegExp(r'^\d{12}$').hasMatch(cleanPhone)) {
      return 'Phone number must be exactly 12 digits';
    }

    if (!cleanPhone.startsWith('92')) {
      return 'Phone number must start with 92';
    }

    return null;
  }

  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Basic email regex pattern
    if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  /// - Minimum 8 characters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate full name
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Please enter your full name';
    }

    return null;
  }

  /// Validate required field (generic)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate budget amount
  static String? validateBudget(String? value) {
    if (value == null || value.isEmpty) {
      return 'Budget is required';
    }

    final budget = double.tryParse(value.trim());
    if (budget == null || budget <= 0) {
      return 'Please enter a valid budget amount';
    }

    return null;
  }

  /// Validate radius (km)
  static String? validateRadius(String? value) {
    if (value == null || value.isEmpty) {
      return 'Radius is required';
    }

    final radius = double.tryParse(value.trim());
    if (radius == null || radius < 0.01 || radius > 50.0) {
      return 'Radius must be between 0.01 and 50 km';
    }

    return null;
  }

  /// Validate task title
  static String? validateTaskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Task title is required';
    }

    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }

    return null;
  }

  /// Validate task description
  static String? validateTaskDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Task description is required';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }

    return null;
  }

  /// Validate bid amount
  static String? validateBidAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bid amount is required';
    }

    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }

    if (amount < 50) {
      return 'Minimum bid amount is Rs 50';
    }

    return null;
  }

  /// Validate bid pitch
  static String? validateBidPitch(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please explain why you are the best fit';
    }

    if (value.trim().length < 50) {
      return 'Pitch must be at least 50 characters';
    }

    return null;
  }
}
