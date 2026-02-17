import 'package:get/get.dart';
import 'package:tasklink/models/tasks/bid_model.dart';

/// Holds UI state for My Posted Tasks screen (Tasker segment and Bids sub-tab).
/// Keeps state out of the screen widget for a cleaner UI layer.
class MyPostedTasksController extends GetxController {
  /// Tasker: true = Tasks section, false = Bids section
  final RxBool taskerSectionIsTasks = true.obs;

  /// Tasker Bids sub-tab: 'Active' or 'Rejected'
  final RxString taskerBidsSubTab = 'Active'.obs;

  /// Last role we loaded data for; reload only when role changes
  final Rxn<String> lastKnownRole = Rxn<String>();

  static const List<String> taskerBidsTabs = ['Active', 'Rejected'];

  void setTaskerSection(bool isTasks) {
    taskerSectionIsTasks.value = isTasks;
  }

  void setBidsSubTab(String tab) {
    taskerBidsSubTab.value = tab;
  }

  /// Returns true if we should trigger a reload (role just changed)
  bool shouldReloadForRole(String? role) {
    if (role == null) return false;
    return role != lastKnownRole.value;
  }

  void markRoleLoaded(String? role) {
    lastKnownRole.value = role;
  }

  Map<String, int> taskerBidCounts(List<BidModel> bids) {
    final active =
        bids.where((b) => b.status.toUpperCase() == 'ACTIVE').length;
    final rejected =
        bids.where((b) => b.status.toUpperCase() == 'REJECTED').length;
    return {'Active': active, 'Rejected': rejected};
  }

  List<BidModel> filterBidsForTasker(List<BidModel> bids, String subTab) {
    if (subTab == 'Active') {
      return bids
          .where((b) => b.status.toUpperCase() == 'ACTIVE')
          .toList();
    }
    return bids
        .where((b) => b.status.toUpperCase() == 'REJECTED')
        .toList();
  }
}
