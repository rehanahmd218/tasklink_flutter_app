import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/features/chat/screens/chat_list_screen.dart';
import 'package:tasklink/features/home/screens/home_screen.dart';
import 'package:tasklink/features/my_posted_tasks/screens/my_posted_tasks_screen.dart';
import 'package:tasklink/features/wallet/screens/wallet_screen.dart';
import 'package:tasklink/features/bids/screens/bids_screen.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final userController = UserController.instance;
  final screens = [
    const HomeScreen(),
    const MyPostedTasksScreen(),
    const BidsScreen(),
    const ChatListScreen(),
    const WalletScreen(),
  ];
}
