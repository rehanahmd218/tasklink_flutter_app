import 'package:flutter/material.dart';

import 'package:tasklink/features/my_posted_tasks/screens/widgets/posted_task_card.dart';
import 'package:tasklink/features/my_posted_tasks/screens/widgets/posted_tasks_tabs.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';

class MyPostedTasksScreen extends StatelessWidget {
  const MyPostedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1a1a0b) : Colors.white,
      appBar: PrimaryAppBar(
        title: 'My Tasks',
        actions: [
          Container(
             margin: const EdgeInsets.only(right: 16),
             decoration: const BoxDecoration(color: TColors.primary, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
             child: IconButton(icon: const Icon(Icons.add, color: Colors.black), onPressed: () {}),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          PostedTasksTabs(
            activeTab: 'Active', 
            onTabSelected: (tab) {}, // TODO: Implement controller
          ),
          
          Expanded(
            child: Container(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey[50], 
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
                     imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCXe4c-QxieaUZxsnb4Esjv3H05aWiJqvf71pDPq7NtqXPJBURlMXU3aBV1WUmutiewgkVQ-yo6LhFdSK3eqM3tZs6t7yeI5RSN2YefqS5qCp_yFsMICvtU8GHoxSyVt43f3IjTlDvxn57CdBltMjnb1j_PUc4-CYA9UsPb4yAMYlt3TOTy6QPqMt0wo5s5xUSlgrJDIOQyZGjn55foAD-voerrlrYeio_R4KXuL4iHIAv2RAiX95kzex2ks0oyOwLwfQos5jie79SP',
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
                     imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAPzLYZC4Yv5-j8pq8dV3zmKCXnub96nJ_wEHtri3cZHuDQeC5x0kIfkHd8v0cEx18hnLeETHAiZAOnHc-mUPukySvz3jhVIDTGBbHHgfNL2oftWAFkt4KnnQqAqVDpSb_qe4NPGw3ndN4eGOQJ6TPHAj9zXLSTxvbdnUgHqwhR3FS3apqRlWz3sJ3I8xVPjR2XnLkbbBbTKteAGly03bOfaXJDzTz_Xx-5L-Cb39JSlQ9AFsMqtIwkA42NZK3XbRIDP5Xu-sHG_7IA',
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
                     imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCj-rEuRpfNndse0Il7NhkDCNdJDtbVVQHp_qOo8KNhsBexKfCU4qasJXY8J9MM-pXp2JqudJ0-TafT925mHGSTgyJ08hTYTE9mFTuEqKfqr60FuYUPFkT6n5kgu5bzfHqFUJ7jUOX_gCYY35dBBD7MtYt9og4FbcuBxJsUhMzwZZwPX10yd7wROmFgBNNgqJH9hCSe_qNn5f5Flgf90MSGnRUwLus4LKhqTYXrnjiYO4KMMdEJLWRi6N_RlbzP72ZL0Q7DogXMbj-F',
                   ),
                   PostedTaskCard(
                      title: 'Draft ADU Floorplan',
                      posted: 'Posted 1d ago',
                      location: 'Remote',
                      price: '\$300 - \$500',
                      statusLabel: 'No bids yet',
                      statusColor: Colors.grey[100]!,
                      statusTextColor: Colors.grey[600]!,
                      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDSn0vMlL_o0jv5UXWKi2_GTg9GYvjRylfs9j-zJ1eUsT_aOD98OPLCrdOOR-X5-6uexRMD9qLNXCzYBWYeVMmMcN5NA4BFc4XFRCXDKENDbARlfn71vADuDCSCDvipBZljF6WjRsmArEld4De8uPJQeMEneOhXiDtKVrNyoi2QZ9K3QZOQB79-o9JlFBvhX9PYX1u4LY4fKw2eYWIwkdFVDzYnw1-QLxrC7Oui8FgvlLfvVuGx6G_xV0HrwoORlE0TTk_hO41ePLZ4',
                      opacity: 0.75,
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
