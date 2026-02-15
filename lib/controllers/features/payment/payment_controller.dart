import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader_with_button.dart';
import 'package:tasklink/controllers/features/tasks/tasks_controller.dart';
import 'package:tasklink/services/payment/payment_service.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

/// Payment Controller
///
/// Handles payment processing state and logic
class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  final PaymentService _paymentService = PaymentService();
  final isLoading = false.obs;

  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Process payment for a task
  Future<void> processPayment({
    required String taskId,
    required String bidId,
    required double amount,
  }) async {
    try {
      FullScreenLoader.show(text: 'Processing Payment...');
      isLoading.value = true;

      final result = await _paymentService.processPayment(
        taskId: taskId,
        bidId: bidId,
      );

      _log.i('Payment successful: $result');

      FullScreenLoader.hide();

      // Refresh tasks to update status in UI
      if (Get.isRegistered<TasksController>()) {
        Get.find<TasksController>().fetchTasks();
      }

      // Show success and instructions
      FullScreenLoaderWithButton.show(
        text: 'Payment Verified Successfully!',
        buttonText: 'Return to Bid',
        onButtonPressed: () {
          FullScreenLoaderWithButton.hide();
          // Return result to trigger bid acceptance in previous screen
          Get.back(result: true);
        },
      );
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;
      ErrorHandler.showErrorPopup(e, buttonText: 'OK');
    }
  }
}
