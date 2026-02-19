import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader_with_button.dart';
import 'package:tasklink/controllers/features/tasks/tasks_controller.dart';
import 'package:tasklink/models/tasks/task_model.dart';
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

      // Update task in list from response so UI rebuilds without full refetch
      if (Get.isRegistered<TasksController>()) {
        final tasksController = Get.find<TasksController>();
        final taskData = result['task'];
        if (taskData is Map<String, dynamic>) {
          try {
            final updatedTask = TaskModel.fromJson(taskData);
            tasksController.updateTaskInList(updatedTask);
          } catch (_) {
            tasksController.fetchTasks();
          }
        } else {
          tasksController.fetchTasks();
        }
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
