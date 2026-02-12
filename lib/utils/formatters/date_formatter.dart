// Date and Time Formatting Utilities
//
// Provides helper functions for formatting dates and times

// Formats a DateTime to a relative time string (e.g., "Posted 2h ago")
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Posted just now';
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return 'Posted ${minutes}m ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return 'Posted ${hours}h ago';
  } else if (difference.inDays < 7) {
    final days = difference.inDays;
    return 'Posted ${days}d ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return 'Posted ${weeks}w ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return 'Posted ${months}mo ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return 'Posted ${years}y ago';
  }
}

// Formats a double as currency string
String formatCurrency(double amount) {
  return 'Rs ${amount.toStringAsFixed(0)}';
}
