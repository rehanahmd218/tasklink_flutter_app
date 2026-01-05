import 'package:flutter/material.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_creation_task_card.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_description_input.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_evidence_section.dart';
import 'package:tasklink/features/disputes/screens/widgets/dispute_reason_dropdown.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({super.key});

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _reasons = [
    'Tasker did not show up',
    'Poor quality of work',
    'Task incomplete',
    'Property damage',
    'Safety concern',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Report an Issue',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: isDark ? const Color(0xFF44432d) : const Color(0xFFe9e8ce), height: 1),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Summary Card
                const DisputeCreationTaskCard(
                  taskTitle: 'Assemble IKEA Desk',
                  taskerName: 'John D.',
                  orderId: '44921',
                  date: 'Sep 12, 2023',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuApH0ayYFsWxOw7gFbcZh1RrJh0LB_uZcLkqS2wyC7kHmHfy_ZXF692Tr33bm5pQ7Z_pK2chXJJ1U1jmeh2POo4Y_jCfKfB_41qxq96qoj_bgksRr96imD3u49lsaQQUR5R04zgI2XTMRB4Bs4zyyX_03cLFZNqxVrcCnrT6d-8Wbz1DuJ4pq22KG7_jurHiXthdhtUd24XfEU-u-FOHrVX7cUN9uLZQ0vGiPVMc9gZCJcDqeYoVYvJqRiISQGx92owkwuHHVIJ7al5',
                ),
                
                const SizedBox(height: 24),
                
                // Reason Dropdown
                DisputeReasonDropdown(
                  selectedReason: _selectedReason,
                  reasons: _reasons,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedReason = newValue;
                    });
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Description Text Area
                DisputeDescriptionInput(controller: _detailsController),
                
                const SizedBox(height: 24),
                
                // Evidence
                const DisputeEvidenceSection(),
              ],
            ),
          ),
          
          // Sticky Bottom Button
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
                    (isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5)).withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {},
                  text: 'Submit Dispute',
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
