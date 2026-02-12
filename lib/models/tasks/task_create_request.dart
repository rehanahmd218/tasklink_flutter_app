/// Task Create Request
///
/// Request model for creating a new task
class TaskCreateRequest {
  final String title;
  final String description;
  final String category;
  final double budget;
  final double latitude;
  final double longitude;
  final String addressText;
  final double radius;
  final DateTime? expiresAt;

  TaskCreateRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    required this.latitude,
    required this.longitude,
    required this.addressText,
    this.radius = 1.0,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'budget': budget.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'address_text': addressText,
      'radius': radius.toString(),
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }
}
