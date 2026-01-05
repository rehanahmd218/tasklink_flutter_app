import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/applied_task_card.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/my_task_card.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/my_tasks_app_bar.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF18181b) : Colors.white,
      appBar: MyTasksAppBar(
        isDark: isDark,
        activeTab: 'In Progress', // TODO: connect to state
        onTabSelected: (tab) {},
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MyTaskCard(
            title: 'Install Ceiling Fan',
            price: '\$85',
            status: 'Assigned',
            statusColor: Colors.green,
            due: 'Due Today, 5pm',
            description: 'Need help replacing an old light fixture with a new ceiling fan in...',
            posterName: 'Michael B.',
            location: '3.2 miles • SoHo, NY',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCwfujNa5Ax0b7V6cl-eZB_6nlq5Wa1D_aVVqdrYUfOGarCPINFh4au-nlV2MCZyWGD4h8rs1gUYK7uJbtWHCV9YJezGXKG2sr9LhmagRhrvHqXoZUH2vwYW9HqoN7lIXCoak8pOaeV9oruEn1MJ151h-lzQCUzUD4drF6L4XUC1lihZDqLaAgrAMcrYaWENpoyYS30zlBstzaJRvfbP0viFbZu15okkLseIVoYrzfvD2AHd-5YckKlgQR5eOTss0zMd3Yig3SIRVci',
            primaryAction: 'Chat',
            secondaryAction: 'Details',
          ),
          const SizedBox(height: 16),
          MyTaskCard(
            title: 'Move Heavy Sofa to 3rd Floor',
            price: '\$120',
            status: 'In Progress',
            statusColor: Colors.blue,
            due: 'Started 1h ago',
            description: 'Large sectional needs to be moved up narrow stairs. Two people...',
            posterName: 'Sarah K.',
            location: '0.8 miles • Tribeca, NY',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCtor0x8S7WFR8IUyUNOYuKU1dq9ykBnwGvRoOF8EKmakp55O9ARlg0eihnS7H4nxVPzergUneA7KXTGB_OvlV38N2ZuSHxODzA7BXG0CofLDSE5BUZzO_KE20BSUAPeoE_aXOLayPcBg0p0J7XT3pkaSicGn8R1aopjN-wz5hvv0GPS2cqKPdTXYPg9stnZlzM-2W9Ry5Q8iuA1TJqLbDbirdmlikj0cahNEh6-VPMOPwHZXTCZh8SYzXcKKtdoUk0S7dqtLJNACex',
            primaryAction: 'Chat',
            secondaryAction: 'Complete',
            isPrimaryActionDark: true,
          ),
          
          const SizedBox(height: 24),
          Text('RECENTLY APPLIED', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 12),
          
          AppliedTaskCard(title: 'Assemble IKEA Wardrobe', subtitle: 'Posted 3h ago • Brooklyn', bid: '\$65'),
          const SizedBox(height: 12),
          AppliedTaskCard(title: 'Dog Walking - 1 Hour', subtitle: 'Posted 5h ago • Central Park', bid: '\$30'),
        ],
      ),
    );
  }

}
