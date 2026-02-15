import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader_with_button.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/services/bids/bid_service.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

import 'package:tasklink/models/tasks/bid_model.dart';

class BidController extends GetxController {
  static BidController get instance => Get.find();

  // Form controllers
  final amountController = TextEditingController();
  final messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Service
  final BidService _bidService = BidService();

  // Loading state
  final isLoading = false.obs;

  // Reactive state for UI
  final rxBidAmount = 0.0.obs;
  final myBids = <BidModel>[].obs;
  final taskBids = <BidModel>[].obs;
  final isLoadingBids = false.obs;

  // Earnings calculation (10% fee)
  double get earnings => rxBidAmount.value * 0.9;

  @override
  void onInit() {
    super.onInit();
    amountController.addListener(() {
      final value = double.tryParse(amountController.text.trim()) ?? 0.0;
      rxBidAmount.value = value;
    });
  }

  @override
  void onClose() {
    amountController.dispose();
    messageController.dispose();
    super.onClose();
  }

  // Edit mode
  final isEdit = false.obs;
  String? bidId;

  void initializeForEdit(BidModel bid) {
    isEdit.value = true;
    bidId = bid.id;
    amountController.text = bid.amount.toInt().toString();
    messageController.text = bid.message ?? '';
    rxBidAmount.value = bid.amount;
  }

  /// Submit a bid (Place or Update)
  Future<void> submitBid(String taskId) async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if user has TASKER role
    final user = UserController.instance.currentUser.value;
    if (user != null && user.role == 'POSTER') {
      ErrorHandler.showErrorPopup(
        'You must switch to Tasker role to place bids.',
        buttonText: 'OK',
      );
      return;
    }

    try {
      FullScreenLoader.show(
        text: isEdit.value ? 'Updating your bid...' : 'Placing your bid...',
      );
      isLoading.value = true;

      // Parse amount
      final amount = double.parse(amountController.text.trim());
      final message = messageController.text.trim();

      if (isEdit.value && bidId != null) {
        await _bidService.updateBid(
          bidId: bidId!,
          amount: amount,
          message: message.isNotEmpty ? message : null,
        );
      } else {
        await _bidService.placeBid(
          taskId: taskId,
          amount: amount,
          message: message.isNotEmpty ? message : null,
        );
      }

      FullScreenLoader.hide();

      // Show success
      FullScreenLoaderWithButton.show(
        text: isEdit.value
            ? 'Bid Updated Successfully!'
            : 'Bid Placed Successfully!',
        buttonText: 'Back to Task',
        onButtonPressed: () {
          FullScreenLoaderWithButton.hide();
          Get.back(result: true); // Return true to refresh previous screen
        },
      );
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  /// Withdraw a bid
  Future<void> withdrawBid(String bidId) async {
    try {
      FullScreenLoader.show(text: 'Withdrawing bid...');
      await _bidService.deleteBid(bidId);
      FullScreenLoader.hide();

      // Refresh list
      Get.back(result: true); // Return to previous screen or close modal?
      // If called from management screen, we might need to refresh list.
      // Usually we go back or stay and refresh.
      // If we are on details, we go back.
      // If we are on list, we refresh.

      // Assuming we are on details or management screen, going back is safe or refreshing.
      // Let's assume we want to refresh the current view.
      // User said "Update/Delete for Bids".

      StatusSnackbar.showSuccess(message: 'Bid withdrawn successfully');

      // If we are in BidManagementScreen (dialog/bottomsheet/page?), we might want to close it.
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  /// Accept a bid (Poster only)
  Future<void> acceptBid(String bidId) async {
    try {
      FullScreenLoader.show(text: 'Accepting Bid...');
      isLoading.value = true;
      await _bidService.acceptBid(bidId);
      FullScreenLoader.hide();

      // Navigate back or show success
      Get.back(result: true);
      ErrorHandler.showSuccess('Bid accepted successfully!');
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  /// Reject a bid (Poster only)
  Future<void> rejectBid(String bidId) async {
    try {
      FullScreenLoader.show(text: 'Rejecting bid...');
      isLoading.value = true;
      await _bidService.rejectBid(bidId);
      FullScreenLoader.hide();

      Get.back(result: true);
      ErrorHandler.showSuccess('Bid rejected.');
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }

  /// Fetch bids for a specific task (Poster view)
  Future<void> fetchBidsForTask(String taskId) async {
    try {
      isLoadingBids.value = true;
      final bids = await _bidService.getBidsForTask(taskId);
      taskBids.assignAll(bids);
    } catch (e) {
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    } finally {
      isLoadingBids.value = false;
    }
  }

  /// Sort task bids by amount (for poster view)
  void sortTaskBidsByAmount({required bool ascending}) {
    final list = List<BidModel>.from(taskBids);
    list.sort((a, b) => ascending
        ? a.amount.compareTo(b.amount)
        : b.amount.compareTo(a.amount));
    taskBids.assignAll(list);
  }

  /// Fetch all bids placed by current user (Tasker view)
  Future<void> fetchMyBids() async {
    try {
      isLoadingBids.value = true;
      final bids = await _bidService.getMyBids();
      myBids.assignAll(bids);
    } catch (e) {
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    } finally {
      isLoadingBids.value = false;
    }
  }
}
