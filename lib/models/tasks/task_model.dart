import 'package:tasklink/models/tasks/task_response_user_model.dart';
import 'package:tasklink/models/tasks/task_media_model.dart';
import 'package:tasklink/models/tasks/bid_model.dart';

/// Task Model
///
/// Represents a complete task from the API
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double budget;
  final String status;
  final bool paymentVerified;
  final double? latitude;
  final double? longitude;
  final String addressText;
  final double radius;
  final DateTime? expiresAt;
  final TaskResponseUserModel? poster;
  final TaskResponseUserModel? assignedTasker;
  final List<TaskMediaModel> media;
  final double distance; // Added distance field
  final int bidCount;
  final BidModel? userBid;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    required this.status,
    required this.paymentVerified,
    this.latitude,
    this.longitude,
    required this.addressText,
    required this.radius,
    this.expiresAt,
    this.poster,
    this.assignedTasker,
    this.media = const [],
    this.distance = 0.0, // Default to 0.0
    this.bidCount = 0,
    this.userBid,
    required this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      budget: _parseDouble(json['budget']),
      status: json['status'] ?? 'BIDDING',
      paymentVerified: json['payment_verified'] ?? false,
      latitude: json['latitude'] != null
          ? _parseDouble(json['latitude'])
          : null,
      longitude: json['longitude'] != null
          ? _parseDouble(json['longitude'])
          : null,
      addressText: json['address_text'] ?? '',
      radius: _parseDouble(json['radius']),
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
      poster: json['poster'] != null
          ? TaskResponseUserModel.fromJson(json['poster'])
          : null,
      assignedTasker: json['assigned_tasker'] != null
          ? TaskResponseUserModel.fromJson(json['assigned_tasker'])
          : null,
      media: json['media'] != null
          ? (json['media'] as List)
                .map((e) => TaskMediaModel.fromJson(e))
                .toList()
          : [],
      distance: _parseDouble(json['distance']), // Parse distance
      bidCount: _parseInt(json['bid_count']),
      userBid: json['user_bid'] != null
          ? BidModel.fromJson(json['user_bid'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'budget': budget,
      'status': status,
      'payment_verified': paymentVerified,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'address_text': addressText,
      'radius': radius,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      if (poster != null) 'poster': poster!.toJson(),
      if (assignedTasker != null) 'assigned_tasker': assignedTasker!.toJson(),
      'media': media.map((e) => e.toJson()).toList(),
      'distance': distance, // Include distance in toJson
      'bid_count': bidCount,
      if (userBid != null) 'user_bid': userBid!.toJson(),
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
