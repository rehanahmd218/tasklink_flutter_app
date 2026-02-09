import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/features/my_posted_tasks/screens/widgets/posted_task_card.dart';
import 'package:tasklink/features/my_posted_tasks/screens/widgets/posted_tasks_tabs.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/applied_task_card.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/my_task_card.dart';
import 'package:tasklink/features/my_tasks/screens/widgets/my_tasks_tabs.dart';
import 'package:tasklink/utils/constants/colors.dart';

class UnifiedMyTasksScreen extends StatefulWidget {
  const UnifiedMyTasksScreen({super.key});

  @override
  State<UnifiedMyTasksScreen> createState() => _UnifiedMyTasksScreenState();
}

class _UnifiedMyTasksScreenState extends State<UnifiedMyTasksScreen> {
  int _selectedMode = 0; // 0 = Poster (Hiring), 1 = Tasker (Working)
  String _activePostedTab = 'Active';
  String _activeAssignedTab = 'In Progress';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF18181b) : Colors.white,
      appBar: PrimaryAppBar(
        title: 'Manage Tasks',
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Mode Toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey[200]!,
                thumbColor: TColors.primary,
                groupValue: _selectedMode,
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: Text(
                      "I'm Hiring",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _selectedMode == 0
                            ? Colors.black
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: Text(
                      "I'm Working",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _selectedMode == 1
                            ? Colors.black
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) setState(() => _selectedMode = value);
                },
              ),
            ),
          ),

          // Content
          Expanded(
            child: _selectedMode == 0
                ? _buildPosterContent(isDark)
                : _buildTaskerContent(isDark),
          ),
        ],
      ),
      floatingActionButton: _selectedMode == 0
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Post Task'),
              backgroundColor: TColors.primary,
              foregroundColor: Colors.black,
            )
          : null,
    );
  }

  Widget _buildPosterContent(bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
          ), // Tabs widget handles internal padding
          child: PostedTasksTabs(
            activeTab: _activePostedTab,
            onTabSelected: (tab) => setState(() => _activePostedTab = tab),
          ),
        ),
        Expanded(
          child: Container(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey[50],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PostedTaskCard(
                  title: 'Lawn Mowing - Front Yard',
                  posted: 'Posted 2h ago',
                  location: 'San Francisco',
                  price: '\$40 - \$50',
                  statusLabel: '5 New Bids',
                  statusIcon: Icons.gavel,
                  statusColor: TColors.primary,
                  statusTextColor: Colors.black,
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCXe4c-QxieaUZxsnb4Esjv3H05aWiJqvf71pDPq7NtqXPJBURlMXU3aBV1WUmutiewgkVQ-yo6LhFdSK3eqM3tZs6t7yeI5RSN2YefqS5qCp_yFsMICvtU8GHoxSyVt43f3IjTlDvxn57CdBltMjnb1j_PUc4-CYA9UsPb4yAMYlt3TOTy6QPqMt0wo5s5xUSlgrJDIOQyZGjn55foAD-voerrlrYeio_R4KXuL4iHIAv2RAiX95kzex2ks0oyOwLwfQos5jie79SP',
                  isNew: true,
                ),
                PostedTaskCard(
                  title: 'Assemble IKEA Bookshelf',
                  posted: 'Posted 5h ago',
                  location: 'Home',
                  price: '\$60 Fixed',
                  statusLabel: 'Assigned',
                  statusIcon: Icons.check_circle,
                  statusColor: Colors.green[100]!,
                  statusTextColor: Colors.green[800]!,
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAPzLYZC4Yv5-j8pq8dV3zmKCXnub96nJ_wEHtri3cZHuDQeC5x0kIfkHd8v0cEx18hnLeETHAiZAOnHc-mUPukySvz3jhVIDTGBbHHgfNL2oftWAFkt4KnnQqAqVDpSb_qe4NPGw3ndN4eGOQJ6TPHAj9zXLSTxvbdnUgHqwhR3FS3apqRlWz3sJ3I8xVPjR2XnLkbbBbTKteAGly03bOfaXJDzTz_Xx-5L-Cb39JSlQ9AFsMqtIwkA42NZK3XbRIDP5Xu-sHG_7IA',
                  hasActions: true,
                  isGrayscale: true,
                ),
                PostedTaskCard(
                  title: 'Kitchen Deep Clean',
                  posted: 'Tomorrow, 10:00 AM',
                  location: 'Downtown',
                  price: '\$120',
                  statusLabel: 'Scheduled',
                  statusIcon: Icons.event,
                  statusColor: Colors.blue[50]!,
                  statusTextColor: Colors.blue[600]!,
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCj-rEuRpfNndse0Il7NhkDCNdJDtbVVQHp_qOo8KNhsBexKfCU4qasJXY8J9MM-pXp2JqudJ0-TafT925mHGSTgyJ08hTYTE9mFTuEqKfqr60FuYUPFkT6n5kgu5bzfHqFUJ7jUOX_gCYY35dBBD7MtYt9og4FbcuBxJsUhMzwZZwPX10yd7wROmFgBNNgqJH9hCSe_qNn5f5Flgf90MSGnRUwLus4LKhqTYXrnjiYO4KMMdEJLWRi6N_RlbzP72ZL0Q7DogXMbj-F',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskerContent(bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MyTasksTabs(
            activeTab: _activeAssignedTab,
            onTabSelected: (tab) => setState(() => _activeAssignedTab = tab),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              MyTaskCard(
                title: 'Install Ceiling Fan',
                price: '\$85',
                status: 'Assigned',
                statusColor: Colors.green,
                due: 'Due Today, 5pm',
                description:
                    'Need help replacing an old light fixture with a new ceiling fan in...',
                posterName: 'Michael B.',
                location: '3.2 miles • SoHo, NY',
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCwfujNa5Ax0b7V6cl-eZB_6nlq5Wa1D_aVVqdrYUfOGarCPINFh4au-nlV2MCZyWGD4h8rs1gUYK7uJbtWHCV9YJezGXKG2sr9LhmagRhrvHqXoZUH2vwYW9HqoN7lIXCoak8pOaeV9oruEn1MJ151h-lzQCUzUD4drF6L4XUC1lihZDqLaAgrAMcrYaWENpoyYS30zlBstzaJRvfbP0viFbZu15okkLseIVoYrzfvD2AHd-5YckKlgQR5eOTss0zMd3Yig3SIRVci',
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
                description:
                    'Large sectional needs to be moved up narrow stairs. Two people...',
                posterName: 'Sarah K.',
                location: '0.8 miles • Tribeca, NY',
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCtor0x8S7WFR8IUyUNOYuKU1dq9ykBnwGvRoOF8EKmakp55O9ARlg0eihnS7H4nxVPzergUneA7KXTGB_OvlV38N2ZuSHxODzA7BXG0CofLDSE5BUZzO_KE20BSUAPeoE_aXOLayPcBg0p0J7XT3pkaSicGn8R1aopjN-wz5hvv0GPS2cqKPdTXYPg9stnZlzM-2W9Ry5Q8iuA1TJqLbDbirdmlikj0cahNEh6-VPMOPwHZXTCZh8SYzXcKKtdoUk0S7dqtLJNACex',
                primaryAction: 'Chat',
                secondaryAction: 'Complete',
                isPrimaryActionDark: true,
              ),

              const SizedBox(height: 24),
              Text(
                'RECENTLY APPLIED',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),

              AppliedTaskCard(
                title: 'Assemble IKEA Wardrobe',
                subtitle: 'Posted 3h ago • Brooklyn',
                bid: '\$65',
              ),
              const SizedBox(height: 12),
              AppliedTaskCard(
                title: 'Dog Walking - 1 Hour',
                subtitle: 'Posted 5h ago • Central Park',
                bid: '\$30',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
