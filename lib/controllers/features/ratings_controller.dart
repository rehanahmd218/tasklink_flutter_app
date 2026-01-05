import 'package:get/get.dart';

class RatingsController extends GetxController {
  final RxString selectedRole = 'tasker'.obs; // 'tasker' or 'poster'

  // Mock data
  final RxDouble averageRating = 4.9.obs;
  final RxInt totalReviews = 32.obs;
  
  // Rating distribution: 5, 4, 3, 2, 1 stars percentages
  final RxList<double> distribution = <double>[0.83, 0.10, 0.05, 0.02, 0.0].obs;

  final RxList<ReviewModel> reviews = <ReviewModel>[
    ReviewModel(
      name: 'Sarah Jenkins',
      date: 'Oct 24, 2023',
      rating: 5.0,
      comment: 'Great work! Arrived on time and fixed the leak quickly. Highly recommend.',
      taskName: 'Plumbing Fix',
      taskIcon: 'plumbing', // Material icon name
      likes: 12,
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAcVGdeCJM4gltaBjZ0C7hs4gcjAR3duxOX0Z2yYbjbtAmWr0fSD4bZHjvbLc6Mhh9nqtP3LOMw5AMqIb8R72tm-BoJDSX69Y3_ALiwf1Z7t3UCdXEnb659wa6cPPdTzM5A98EMLA4MtbIGidSa4tU_zruHTWt-qGuHjqbKRVwnWKOek08n4NIBuzTe0KZOR2kSpiw40U4n37e6pJDGwi1dpIVW2Vn-DA__gHbzWEQqlN6pr08UUJAzFrkZw4wMSh2kIvUzptBAbiWM',
    ),
    ReviewModel(
      name: 'Mike Ross',
      date: 'Oct 20, 2023',
      rating: 5.0,
      comment: 'Excellent communication and very professional. Would hire again.',
      taskName: 'Furniture Assembly',
      taskIcon: 'chair',
      likes: 8,
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAiBm9zEPdh4lxMDtgslgpc916rF_K4G9trdbENzOlHxMFx3JmAIlBGSv3TFcsoTVKBiIlw2CNgI7udBHqJVNdix91fmx8pgTWMZiHy5GaeizI4eEpYUjuwa-BWF8iXzzQu5nZb1KDMcXpNnN-Rm2gQiMKd55fNBySR7etCwPlHOpuwUw54ypF2PLn6N09CN6YxSddwMY4YxURfMnfLJplz0ZjI-1GFLOp5F5OXFDXQgnb4HUzH5wohqzaaj5nC4W_Oek3CvJMBoKfY',
    ),
    ReviewModel(
      name: 'Jessica Pearson',
      date: 'Sep 15, 2023',
      rating: 4.0,
      comment: 'Good job overall, but a bit later than expected.',
      taskName: 'Lawn Mowing',
      taskIcon: 'grass',
      likes: 2,
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB_ZGgNHvfnK16oS1FHWtPoFak0Xvt_pyupEWyRAyuzgcoXaDFyLF1lpZCoWS7_jHaFWC8WQtwInjB2Vg-LxJjeZLKWTTqLddFmJTLGQooV6q48Bws6l1jMfQzZJARb3q_vjHUUixckQA7vdh8PVaa6k3vlmCCXT1SDmEszfUhdiOR7_kGgLgYqpViCoMGxstlVEszYWf4Dh7JbO-GKcG5CVmqC49-mZkByNEOvNit8isJ6agembna3FmcuPcZnT0UPmbR7L9Y7V8dv',
    ),
  ].obs;

  void toggleRole(String role) {
    selectedRole.value = role;
    // Filter reviews logic here
  }
}

class ReviewModel {
  final String name;
  final String date;
  final double rating;
  final String comment;
  final String taskName;
  final String taskIcon;
  final int likes;
  final String avatarUrl;

  ReviewModel({
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.taskName,
    required this.taskIcon,
    required this.likes,
    required this.avatarUrl,
  });
}
