import 'package:get/get.dart';

class TaskDetailsTaskerController extends GetxController {
  final RxString taskId = '123'.obs;
  final RxString taskTitle = 'Assemble IKEA Furniture'.obs;
  final RxString priceRange = '\$50 - \$70'.obs;
  final RxString postedTime = 'Posted 2h ago'.obs;
  
  // Poster info
  final RxString posterName = 'Sarah J.'.obs;
  final RxString posterAvatar = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAeTNI267OH42tMNeuZ5RBsIHl7oFG3nNiCGwFtuvC8_w_aY7p_nBdoGbpGn8K2_YFj72G1t21HiBQlKRR2YAUMCKo5utOcSmqzvkIbnIF3t1BD8LF3y9l6948WUM83FM6E45Yz_qG9RLzxaGFK-97ChT7av0DGGQQgk7i31wO9NFeBXm4xqcQwIHsI8JRiU7aot_RebjdARNiZRNpZ9unEI1RvpwXl98LF3GLtQoMFye4xQLWqJxUMdXuIvDeknJfKOiXtLf8DTUil'.obs;
  final RxDouble posterRating = 4.9.obs;
  final RxInt posterReviews = 120.obs;

  // Details
  final RxString date = 'Today, 2:00 PM'.obs;
  final RxString category = 'Assembly'.obs;
  final RxString location = 'SoHo, New York • 3.2 miles away'.obs;
  final RxString description = 'I have a large Pax wardrobe from IKEA that needs assembly. It\'s the 236cm height version with sliding doors.\n\nAll parts are in the boxes in the bedroom where it needs to be built. There is enough space to work.\n\nPlease bring your own tools (screwdriver, drill, etc.). I will be home to buzz you in.'.obs;
  final RxString mapImageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuDCmHJUj7e2sEOM5Df_dG57kg6DOo1rHlrz8kYw_Knads_lcF59fa09Ze7JpDmbs1CzrovkoiROs0TKsD2WBTEt43jm_qN0D9_Itwb69LvKrrcHkk1k2XVg5Y8VWfg7Mk0-mGoENnALkDiYqRvgNxIjqbywzeP8tk40NICkOloNOQr-3hG04QA49bR3pCwpmxYvRRJZse0FaoeC2BmjYun2bliRI9HQBhJGm5t9QZUWFLqA8lxSQIFBwr_tpe5Nt-lFwM8WORidOCnS'.obs;

  // State
  final RxBool hasBid = false.obs;
  final RxString currentBid = '\$65.00'.obs;

  void placeBid() {
    // Logic to place bid
    hasBid.value = true;
    Get.snackbar('Success', 'Bid placed successfully!');
  }

  void cancelBid() {
    hasBid.value = false;
  }

  void shareTask() {
    // Share logic
  }
}
