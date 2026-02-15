class Routes {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const RESET_PASSWORD = '/reset-password';
  static const VERIFICATION = '/verification';

  static const HOME = '/'; // Main Navigation Container
  static const HOME_TAB =
      '/home-tab'; // Individual Home Tab if needed, but usually handled by NavMenu

  static const TASK_DETAILS = '/task-details';
  static const TASK_DETAILS_TASKER = '/task-details-tasker';

  static const POST_TASK = '/post-task';
  static const POST_TASK_MEDIA = '/post-task-media';
  static const PLACE_BID = '/place-bid';
  static const MY_POSTED_TASKS = '/my-posted-tasks';
  static const MY_TASKS = '/my-tasks';
  static const BID_MANAGEMENT = '/bid-management';

  static const CHAT_LIST = '/chat-list';
  static const CHAT_ROOM = '/chat-room';

  static const DISPUTE = '/dispute';
  static const NOTIFICATIONS = '/notifications';
  static const PAYMENT = '/payment';

  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const PORTFOLIO = '/portfolio';

  static const WRITE_REVIEW = '/write-review';
  static const COMPLETE_RATINGS = '/complete-ratings';

  static const SETTINGS = '/settings';

  static const WALLET = '/wallet';
  static const TOP_UP = '/top-up';
  static const WITHDRAW = '/withdraw';

  static const DASHBOARD = '/in-progress-dashboard';

  static const BIDS_TASKER = '/bids-tasker';
  static const BIDS_POSTER = '/bids-poster';

  static List<String> all = [
    LOGIN,
    REGISTER,
    FORGOT_PASSWORD,
    RESET_PASSWORD,
    VERIFICATION,
    HOME,
    HOME_TAB,
    TASK_DETAILS,
    TASK_DETAILS_TASKER,
    POST_TASK,
    PLACE_BID,
    MY_POSTED_TASKS,
    MY_TASKS,
    BID_MANAGEMENT,
    CHAT_LIST,
    CHAT_ROOM,
    DISPUTE,
    NOTIFICATIONS,
    PAYMENT,
    PROFILE,
    EDIT_PROFILE,
    PORTFOLIO,
    WRITE_REVIEW,
    COMPLETE_RATINGS,
    SETTINGS,
    WALLET,
    TOP_UP,
    WITHDRAW,
    DASHBOARD,
  ];
}
