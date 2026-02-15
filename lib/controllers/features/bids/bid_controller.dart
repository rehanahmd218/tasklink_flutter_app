import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader_with_button.dart';
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

  /// Place a bid on a task
  Future<void> placeBid(String taskId) async {
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
      FullScreenLoader.show(text: 'Placing your bid...');
      isLoading.value = true;

      // Parse amount
      final amount = double.parse(amountController.text.trim());
      final message = messageController.text.trim();

      await _bidService.placeBid(
        taskId: taskId,
        amount: amount,
        message: message.isNotEmpty ? message : null,
      );

      FullScreenLoader.hide();

      // Show success
      FullScreenLoaderWithButton.show(
        text: 'Bid Placed Successfully!',
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
