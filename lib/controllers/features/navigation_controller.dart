import 'package:get/get.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/chat/screens/chat_list_screen.dart';
import 'package:tasklink/features/home/screens/home_screen.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/my_posted_tasks_screen.dart';
import 'package:tasklink/features/wallet/screens/wallet_screen.dart';
import 'package:tasklink/features/profile/screens/profile_screen.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final userController = UserController.instance;

  // Updated screens list to match new navigation
  final screens = [
    const HomeScreen(),
    const MyPostedTasksScreen(),
    const ChatListScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];
}
