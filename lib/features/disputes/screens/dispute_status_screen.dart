import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_description_view.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_info_table.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_status_banner.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_status_task_card.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';

class DisputeStatusScreen extends StatelessWidget {
  const DisputeStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Dispute Details',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Banner
            const DisputeStatusBanner(
              status: 'Under Review',
              description: 'Our team is currently investigating the evidence provided by both parties. This process usually takes 24-48 hours.',
            ),
            
            const SizedBox(height: 24),
            
            // Task Context Card
            const DisputeStatusTaskCard(),
            
            const SizedBox(height: 24),
            
            // Dispute Information
            const DisputeInfoTable(
              data: {
                'ID': '#82910',
                'Date Raised': 'Oct 25, 2023',
                'Reason': 'No Show',
                'Requested': 'Full Refund',
              },
            ),
            
            const SizedBox(height: 24),
            
            // Your Description
            const DisputeDescriptionView(
              description: 'I waited for 2 hours at the property, but the tasker never arrived. I tried calling them three times and sent multiple messages through the app, but they stopped replying after 1:45 PM. I needed the lawn mowed before the guests arrived at 5 PM.',
            ),
            
            const SizedBox(height: 32),
            
            // Actions
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {},
                text: 'Contact Support',
                icon: Icons.mail,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: Text('Cancel Dispute', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[500])),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

}
