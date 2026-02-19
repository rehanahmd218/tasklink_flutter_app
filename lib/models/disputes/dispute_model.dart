/// Dispute model from the API.
/// Backend: id, task, task_title, raised_by, reason, status, resolution_note, resolution_outcome, resolved_by, resolved_at, created_at, media
class DisputeModel {
  final String id;
  final String taskId;
  final String taskTitle;
  final String reason;
  final String status; // OPEN, UNDER_REVIEW, RESOLVED
  final String? resolutionNote;
  final String? resolutionOutcome; // FAVOR_TASKER, FAVOR_POSTER
  final String? resolvedAt;
  final String createdAt;

  DisputeModel({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.reason,
    required this.status,
    this.resolutionNote,
    this.resolutionOutcome,
    this.resolvedAt,
    required this.createdAt,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['id']?.toString() ?? '',
      taskId: json['task']?.toString() ?? '',
      taskTitle: json['task_title'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'OPEN',
      resolutionNote: json['resolution_note'] as String?,
      resolutionOutcome: json['resolution_outcome'] as String?,
      resolvedAt: json['resolved_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  bool get isResolved => status == 'RESOLVED';
  String get statusDisplay {
    switch (status) {
      case 'OPEN':
        return 'Open';
      case 'UNDER_REVIEW':
        return 'Under Review';
      case 'RESOLVED':
        return 'Resolved';
      default:
        return status;
    }
  }
}
