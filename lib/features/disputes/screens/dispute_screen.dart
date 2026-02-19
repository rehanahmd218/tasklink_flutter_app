import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/common/widgets/media_picker_section.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_creation_task_card.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_description_input.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_reason_dropdown.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/services/tasks/task_service.dart';
import 'package:tasklink/services/disputes/dispute_service.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/utils/http/api_config.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({super.key});

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  final TaskService _taskService = TaskService();
  final DisputeService _disputeService = DisputeService();
  final ImagePicker _picker = ImagePicker();

  TaskModel? _task;
  bool _loading = true;
  String _error = '';
  bool _submitting = false;
  bool _isPoster = true;
  List<String> _reasons = [];
  final List<XFile> _mediaFiles = [];

  static const List<String> _reasonsPosterFallback = [
    'Tasker did not show up',
    'Poor quality of work',
    'Task incomplete',
    'Property damage',
    'Safety concern',
    'Other',
  ];
  static const List<String> _reasonsTaskerFallback = [
    'Poster did not provide access',
    'Payment or scope dispute',
    'Unfair cancellation',
    'Safety concern',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _loadTask() async {
    final args = Get.arguments as Map<String, dynamic>?;
    final taskId = args?['taskId']?.toString();
    _isPoster = args?['isPoster'] as bool? ?? true;
    if (taskId == null || taskId.isEmpty) {
      setState(() {
        _error = 'No task specified';
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final task = await _taskService.getTaskById(taskId);
      final raiser = _isPoster ? 'poster' : 'tasker';
      List<String> reasons = _isPoster ? _reasonsPosterFallback : _reasonsTaskerFallback;
      try {
        reasons = await _disputeService.getReasonChoices(raiser: raiser);
        if (reasons.isEmpty) reasons = _isPoster ? _reasonsPosterFallback : _reasonsTaskerFallback;
      } catch (_) {}
      setState(() {
        _task = task;
        _reasons = reasons;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  Future<void> _pickMedia() async {
    if (_mediaFiles.length >= 3) {
      StatusSnackbar.showWarning(message: 'You can add up to 3 photos.');
      return;
    }
    try {
      final picked = await _picker.pickMultiImage();
      if (picked.isEmpty) return;
      final remaining = 3 - _mediaFiles.length;
      final toAdd = picked.take(remaining).toList();
      setState(() => _mediaFiles.addAll(toAdd));
      if (picked.length > remaining) {
        StatusSnackbar.showWarning(message: 'Only $remaining photo(s) added. Maximum is 3.');
      }
    } catch (e) {
      StatusSnackbar.showError(message: 'Failed to pick images: $e');
    }
  }

  String _taskImageUrl() {
    if (_task == null || _task!.media.isEmpty) return '';
    final m = _task!.media.first;
    if (m.file.isEmpty) return '';
    return ApiConfig.mediaFileUrl(m.file);
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  Future<void> _submitDispute() async {
    if (_task == null) return;
    final reasonText = _selectedReason ?? '';
    final details = _detailsController.text.trim();
    final reason = details.isEmpty ? reasonText : '$reasonText: $details';
    if (reason.isEmpty) {
      StatusSnackbar.showWarning(message: 'Please select a reason for your dispute and/or provide details.');
      return;
    }
    setState(() => _submitting = true);
    try {
      final dispute = await _disputeService.createDispute(taskId: _task!.id, reason: reason);
      for (final x in _mediaFiles) {
        await _disputeService.uploadDisputeMedia(dispute.id, File(x.path));
      }
      setState(() => _submitting = false);
      Get.offNamed(Routes.DISPUTE_STATUS, arguments: {'disputeId': dispute.id});
      StatusSnackbar.showSuccess(message: 'Dispute submitted successfully');
    } catch (e) {
      setState(() => _submitting = false);
      StatusSnackbar.showError(message: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
        appBar: PrimaryAppBar(title: 'Report an Issue'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error.isNotEmpty || _task == null) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
        appBar: PrimaryAppBar(title: 'Report an Issue'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error.isEmpty ? 'Task not found' : _error, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton(onPressed: () => Get.back(), child: const Text('Back')),
              ],
            ),
          ),
        ),
      );
    }

    final task = _task!;
    final taskerName = task.assignedTasker?.fullName ?? 'Tasker';
    final imageUrl = _taskImageUrl();
    final placeholderImage =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuApH0ayYFsWxOw7gFbcZh1RrJh0LB_uZcLkqS2wyC7kHmHfy_ZXF692Tr33bm5pQ7Z_pK2chXJJ1U1jmeh2POo4Y_jCfKfB_41qxq96qoj_bgksRr96imD3u49lsaQQUR5R04zgI2XTMRB4Bs4zyyX_03cLFZNqxVrcCnrT6d-8Wbz1DuJ4pq22KG7_jurHiXthdhtUd24XfEU-u-FOHrVX7cUN9uLZQ0vGiPVMc9gZCJcDqeYoVYvJqRiISQGx92owkwuHHVIJ7al5';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Report an Issue',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? const Color(0xFF44432d) : const Color(0xFFe9e8ce),
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisputeCreationTaskCard(
                  taskTitle: task.title,
                  taskerName: taskerName,
                  orderId: task.id.length > 8 ? task.id.substring(0, 8) : task.id,
                  date: _formatDate(task.createdAt),
                  imageUrl: imageUrl.isNotEmpty ? imageUrl : placeholderImage,
                ),
                const SizedBox(height: 24),
                DisputeReasonDropdown(
                  selectedReason: _selectedReason,
                  reasons: _reasons,
                  onChanged: (newValue) => setState(() => _selectedReason = newValue),
                ),
                const SizedBox(height: 24),
                DisputeDescriptionInput(controller: _detailsController),
                const SizedBox(height: 24),
                MediaPickerSection(
                  title: 'Evidence (optional)',
                  subtitle: 'Add up to 3 photos to support your dispute.',
                  images: _mediaFiles,
                  maxFiles: 3,
                  onAddRequest: _pickMedia,
                  onRemove: (index) => setState(() => _mediaFiles.removeAt(index)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
                    (isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5))
                        .withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: _submitting ? null : _submitDispute,
                  text: _submitting ? 'Submitting...' : 'Submit Dispute',
                  icon: Icons.send,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
