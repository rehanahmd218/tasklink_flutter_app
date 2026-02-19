import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';

class InProgressDashboardController extends GetxController {
  // Mock data for now, replace with actual Task model later
  final RxString taskTitle = 'Assemble IKEA Desk'.obs;
  final RxString taskPrice = '45.00'.obs;
  final RxString taskerName = 'Alex'.obs;
  final RxString chatPreview = 'Hey, I just arrived at the location.'.obs;
  final RxList<String> evidencePhotos = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAN8Wndc4xEtl9rWbTF_vs_jQaXri1T6-0U2CqPtokt6N-zmfAo-h9F_VbpQ_fnjL-y_suqbJeivDNLfkNRfDoBhwAIH_-mTcVEAeP-1FWjqe4YBguO0XMFV_jA_2xFsSuwHOHr5E-JsMn8PwZjsyUMf7q6m7VvkwZoSxETW6pmbIGxvK7ye794GO_pYQKvxyvvcShV-8AGYuOOmwVNAJZtO1lDx8wGYLVCd17kFeLiX83p26S5gXwEJsjqeQ4D_rEk22-_NvhkGiyY'
  ].obs;

  void markAsCompleted() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Completion'),
        content: const Text('Are you sure you want to mark this task as completed?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Implement completion logic
              StatusSnackbar.showInfo(message: 'Task marked as completed. Awaiting review.');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void reportIssue() {
    StatusSnackbar.showInfo(message: 'Reporting feature coming soon');
  }

  void openChat() {
    // Navigate to chat
  }

  void addPhoto() {
    // Pick image logic
  }
}
