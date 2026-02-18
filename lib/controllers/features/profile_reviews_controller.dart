import 'package:get/get.dart';
import 'package:tasklink/services/reviews/review_service.dart';

/// Holds first 2 reviews and total count for the profile screen.
class ProfileReviewsController extends GetxController {
  final RxList<ProfileReviewItem> firstTwo = <ProfileReviewItem>[].obs;
  final RxInt totalCount = 0.obs;
  final RxBool isLoading = true.obs;

  static const String _placeholderAvatar =
      'https://ui-avatars.com/api/?name=User&size=96';

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final list = await ReviewService().getMyReviewsReceived();
      totalCount.value = list.length;
      firstTwo.value = list.take(2).map((r) {
        return ProfileReviewItem(
          name: r.reviewer.fullName.isNotEmpty ? r.reviewer.fullName : 'User',
          rating: r.rating.toDouble(),
          review: r.comment,
          time: r.formattedDate,
          avatarUrl: r.reviewer.profileImage ?? _placeholderAvatar,
        );
      }).toList();
    } catch (_) {
      firstTwo.clear();
      totalCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }
}

class ProfileReviewItem {
  final String name;
  final double rating;
  final String review;
  final String time;
  final String avatarUrl;

  ProfileReviewItem({
    required this.name,
    required this.rating,
    required this.review,
    required this.time,
    required this.avatarUrl,
  });
}
