import 'package:get/get.dart';
import 'package:tasklink/models/reviews/review_model.dart' as api;
import 'package:tasklink/services/reviews/review_service.dart';

class RatingsController extends GetxController {
  final RxString selectedRole = 'tasker'.obs; // 'tasker' or 'poster'

  final RxDouble averageRating = 0.0.obs;
  final RxInt totalReviews = 0.obs;
  final RxList<double> distribution = <double>[0.0, 0.0, 0.0, 0.0, 0.0].obs;

  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString loadError = ''.obs;

  /// If set, reviews are for this user (e.g. from public profile). Otherwise current user's received reviews.
  String? userId;

  static const String _placeholderAvatar =
      'https://ui-avatars.com/api/?name=User&size=96';

  List<api.ReviewModel>? _lastFetchedList;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments is Map ? Get.arguments['userId']?.toString() : null;
    loadReviews();
  }

  Future<void> loadReviews() async {
    isLoading.value = true;
    loadError.value = '';
    try {
      final List<api.ReviewModel> list = userId != null
          ? await ReviewService().getReviewsForUser(userId!)
          : await ReviewService().getMyReviewsReceived();
      _lastFetchedList = list;
      _applyList(list);
    } catch (e) {
      loadError.value = e.toString();
      _lastFetchedList = null;
      reviews.clear();
      averageRating.value = 0;
      totalReviews.value = 0;
      distribution.value = [0.0, 0.0, 0.0, 0.0, 0.0];
    } finally {
      isLoading.value = false;
    }
  }

  void _applyList(List<api.ReviewModel> list) {
    final role = selectedRole.value;
    final filtered = list
        .where((r) => r.revieweeRole == role)
        .toList();
    reviews.value = filtered.map(_toReviewModel).toList();
    _computeSummary(filtered);
  }

  ReviewModel _toReviewModel(api.ReviewModel r) {
    return ReviewModel(
      name: r.reviewer.fullName.isNotEmpty ? r.reviewer.fullName : 'User',
      date: r.formattedDate,
      rating: r.rating.toDouble(),
      comment: r.comment,
      taskName: r.taskTitle ?? 'Task',
      taskIcon: 'work',
      likes: 0,
      avatarUrl: r.reviewer.profileImage ?? _placeholderAvatar,
    );
  }

  void _computeSummary(List<api.ReviewModel> list) {
    if (list.isEmpty) {
      averageRating.value = 0;
      totalReviews.value = 0;
      distribution.value = [0.0, 0.0, 0.0, 0.0, 0.0];
      return;
    }
    final counts = [0, 0, 0, 0, 0]; // 5,4,3,2,1 stars
    double sum = 0;
    for (final r in list) {
      final star = r.rating.clamp(1, 5);
      sum += star;
      if (star >= 1 && star <= 5) counts[5 - star]++;
    }
    totalReviews.value = list.length;
    averageRating.value = list.isNotEmpty ? sum / list.length : 0;
    final n = list.length.toDouble();
    distribution.value = counts.map((c) => n > 0 ? c / n : 0.0).toList();
  }

  void toggleRole(String role) {
    selectedRole.value = role;
    final list = _lastFetchedList;
    if (list == null) return;
    final roleFiltered = list.where((r) => r.revieweeRole == role).toList();
    reviews.value = roleFiltered.map(_toReviewModel).toList();
    _computeSummary(roleFiltered);
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
