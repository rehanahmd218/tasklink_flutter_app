import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_description_view.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_info_table.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_status_banner.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_status_task_card.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/models/disputes/dispute_model.dart';
import 'package:tasklink/services/disputes/dispute_service.dart';
import 'package:tasklink/utils/http/api_config.dart';

class DisputeStatusScreen extends StatefulWidget {
  final String disputeId;

  const DisputeStatusScreen({super.key, required this.disputeId});

  @override
  State<DisputeStatusScreen> createState() => _DisputeStatusScreenState();
}

class _DisputeStatusScreenState extends State<DisputeStatusScreen> {
  final DisputeService _disputeService = DisputeService();
  DisputeModel? _dispute;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDispute();
  }

  Future<void> _loadDispute() async {
    if (widget.disputeId.isEmpty) {
      setState(() {
        _error = 'No dispute specified';
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final dispute = await _disputeService.getDisputeById(widget.disputeId);
      setState(() {
        _dispute = dispute;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
        appBar: PrimaryAppBar(title: 'Dispute Details'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error.isNotEmpty || _dispute == null) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
        appBar: PrimaryAppBar(title: 'Dispute Details'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error.isEmpty ? 'Dispute not found' : _error, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton(onPressed: () => Get.back(), child: const Text('Back')),
              ],
            ),
          ),
        ),
      );
    }

    final d = _dispute!;
    String statusDescription;
    if (d.status == 'RESOLVED') {
      statusDescription = d.resolutionNote?.isNotEmpty == true
          ? d.resolutionNote!
          : 'This dispute has been resolved.';
    } else if (d.status == 'UNDER_REVIEW') {
      statusDescription = 'Our team is investigating. This usually takes 24-48 hours.';
    } else {
      statusDescription = 'Your dispute has been received and will be reviewed shortly.';
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Dispute Details',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DisputeStatusBanner(status: d.statusDisplay, description: statusDescription),
            const SizedBox(height: 24),
            DisputeStatusTaskCard(taskTitle: d.taskTitle),
            const SizedBox(height: 24),
            DisputeInfoTable(
              data: {
                'ID': '#${d.id.length > 8 ? d.id.substring(0, 8) : d.id}',
                'Date Raised': _formatDate(d.createdAt),
                'Reason': d.reason,
                if (d.isResolved && d.resolutionOutcome != null)
                  'Outcome': d.resolutionOutcome == 'FAVOR_TASKER' ? 'Favor Tasker' : 'Favor Poster',
              },
            ),
            if (d.media.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2c2b14) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EVIDENCE UPLOADED',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: d.media.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final m = d.media[i];
                          final url = ApiConfig.mediaFileUrl(m.fileUrl ?? '');
                          if (url.isEmpty) return const SizedBox.shrink();
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image_outlined),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            DisputeDescriptionView(description: d.reason),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {},
                text: 'Contact Support',
                icon: Icons.mail,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
