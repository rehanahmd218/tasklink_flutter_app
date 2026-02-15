import 'package:tasklink/authentication/models/user_model.dart';
import 'package:tasklink/models/tasks/task_response_user_model.dart';

/// Bid Model
///
/// Represents a bid placed on a task by a tasker
class BidModel {
  final String id;
  final String task;
  final String? taskTitle;
  final TaskResponseUserModel? tasker;
  final double amount;
  final String? message;
  final String status; // 'ACTIVE', 'ACCEPTED', 'REJECTED'
  final DateTime createdAt;

  BidModel({
    required this.id,
    required this.task,
    this.taskTitle,
    this.tasker,
    required this.amount,
    this.message,
    required this.status,
    required this.createdAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id']?.toString() ?? '',
      task: json['task']?.toString() ?? '',
      taskTitle: json['task_title'],
      tasker: json['tasker'] != null
          ? TaskResponseUserModel.fromJson(json['tasker'])
          : null,
      amount: _parseDouble(json['amount']),
      message: json['message'],
      status: json['status'] ?? 'ACTIVE',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      if (taskTitle != null) 'task_title': taskTitle,
      if (tasker != null) 'tasker': tasker!.toJson(),
      'amount': amount,
      if (message != null) 'message': message,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
