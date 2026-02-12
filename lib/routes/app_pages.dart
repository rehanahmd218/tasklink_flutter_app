import 'package:get/get.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/models/tasks/task_model.dart';

import '../navigation_menu.dart';
import '../authentication/screens/splash_screen/splash_screen.dart';
import '../authentication/screens/login_screen/login_screen.dart';
import '../authentication/screens/registration_screen/registration_screen.dart';
import '../authentication/screens/forgot_password_screen/forgot_password_screen.dart';
import '../authentication/screens/reset_password_screen/reset_password_screen.dart';
import '../authentication/screens/verification_screen/verification_screen.dart';

import '../features/home/screens/home_screen.dart';
import '../features/task_details/screens/task_details_screen.dart';
import '../features/task_details/screens/task_details_tasker_screen.dart';
import '../features/post_task/screens/post_task_screen.dart';
import '../features/post_task/screens/post_task_media_screen.dart';
import '../features/place_bid/screens/place_bid_screen.dart';
import '../features/my_posted_tasks/screens/my_posted_tasks_screen.dart';
import '../features/my_tasks/screens/my_tasks_screen.dart';
import '../features/bid_management/screens/bid_management_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/chat/screens/chat_room_screen.dart';
import '../features/disputes/screens/dispute_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/payment/screens/payment_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/edit_profile/edit_profile_screen.dart';
// import '../features/profile/screens/portfolio/portfolio_screen.dart'; // TODO: Check if exists
import '../features/reviews/screens/write_review_screen.dart';
import '../features/ratings/screens/complete_ratings_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/wallet/screens/wallet_screen.dart';
import '../features/wallet/screens/top_up/top_up_screen.dart';
import '../features/wallet/screens/withdraw/withdraw_screen.dart';
import '../features/dashboard/screens/in_progress_dashboard_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: Routes.LOGIN, page: () => const LoginScreen()),
    GetPage(name: Routes.REGISTER, page: () => const RegistrationScreen()),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(name: Routes.VERIFICATION, page: () => const VerificationScreen()),

    GetPage(name: Routes.HOME, page: () => const NavigationMenu()),
    GetPage(
      name: Routes.HOME_TAB,
      page: () => const HomeScreen(),
    ), // Usually embedded, but route accessible

    GetPage(
      name: Routes.TASK_DETAILS,
      page: () {
        final arguments = Get.arguments;

        // Handle both old (task object) and new (taskId) argument formats
        if (arguments is Map<String, dynamic> &&
            arguments.containsKey('taskId')) {
          // New format: taskId passed
          return TaskDetailsScreen(taskId: arguments['taskId'] as String);
        } else if (arguments is TaskModel) {
          // Old format: task object passed (for backward compatibility)
          return TaskDetailsScreen(task: arguments);
        } else {
          // Fallback - should not happen
          throw Exception('Invalid arguments for TaskDetailsScreen');
        }
      },
    ),
    GetPage(
      name: Routes.TASK_DETAILS_TASKER,
      page: () => const TaskDetailsTaskerScreen(),
    ),

    GetPage(name: Routes.POST_TASK, page: () => const PostTaskScreen()),
    GetPage(
      name: Routes.POST_TASK_MEDIA,
      page: () => const PostTaskMediaScreen(),
    ),
    GetPage(name: Routes.PLACE_BID, page: () => const PlaceBidScreen()),
    GetPage(
      name: Routes.MY_POSTED_TASKS,
      page: () => const MyPostedTasksScreen(),
    ),
    GetPage(name: Routes.MY_TASKS, page: () => const MyTasksScreen()),
    GetPage(
      name: Routes.BID_MANAGEMENT,
      page: () => const BidManagementScreen(),
    ),

    GetPage(name: Routes.CHAT_LIST, page: () => const ChatListScreen()),
    GetPage(name: Routes.CHAT_ROOM, page: () => const ChatRoomScreen()),

    GetPage(name: Routes.DISPUTE, page: () => const DisputeScreen()),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsScreen(),
    ),
    GetPage(name: Routes.PAYMENT, page: () => const PaymentScreen()),

    GetPage(name: Routes.PROFILE, page: () => const ProfileScreen()),
    GetPage(name: Routes.EDIT_PROFILE, page: () => const EditProfileScreen()),

    // GetPage(name: Routes.PORTFOLIO, page: () => const PortfolioScreen()),
    GetPage(name: Routes.WRITE_REVIEW, page: () => const WriteReviewScreen()),
    GetPage(
      name: Routes.COMPLETE_RATINGS,
      page: () => const CompleteRatingsScreen(),
    ),

    GetPage(name: Routes.SETTINGS, page: () => const SettingsScreen()),

    GetPage(name: Routes.WALLET, page: () => const WalletScreen()),
    GetPage(name: Routes.TOP_UP, page: () => const TopUpScreen()),
    GetPage(name: Routes.WITHDRAW, page: () => const WithdrawScreen()),

    GetPage(
      name: Routes.DASHBOARD,
      page: () => const InProgressDashboardScreen(),
    ),
  ];
}
