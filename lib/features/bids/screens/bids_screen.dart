import 'package:flutter/material.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/applied_task_card.dart';

class BidsScreen extends StatelessWidget {
  const BidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF18181b) : Colors.white,
      appBar: PrimaryAppBar(title: 'My Bids', showBackButton: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AppliedTaskCard(
            title: 'Assemble IKEA Wardrobe',
            subtitle: 'Posted 3h ago • Brooklyn',
            bid: '\$65',
          ),
          SizedBox(height: 12),
          AppliedTaskCard(
            title: 'Dog Walking - 1 Hour',
            subtitle: 'Posted 5h ago • Central Park',
            bid: '\$30',
          ),
          SizedBox(height: 12),
          AppliedTaskCard(
            title: 'Website Redesign',
            subtitle: 'Posted 1d ago • Remote',
            bid: '\$500',
          ),
        ],
      ),
    );
  }
}
