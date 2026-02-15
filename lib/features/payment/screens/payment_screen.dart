import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/payment/payment_controller.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_bottom_bar.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_breakdown.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_method_card.dart';
import 'package:tasklink/features/payment/screens/widgets/payment_task_card.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final task = args['task'] as TaskModel?;
    final bid = args['bid'] as BidModel?;
    // Support taskId (string) argument if task object not passed?
    // Ideally we should have the full objects here for display.
    // If taskId string passed, we might need to fetch task, but let's assume objects passed for now.

    if (task == null || bid == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Missing task or bid details')),
      );
    }

    final controller = Get.put(PaymentController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate fees
    final amount = bid.amount;
    final serviceFee = amount * 0.05; // 5% fee example
    final total = amount + serviceFee;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF23220f)
          : const Color(0xFFf8f8f5),
      appBar: const PrimaryAppBar(title: 'Secure Payment'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Task Card
                PaymentTaskCard(
                  imageUrl: task.media.isNotEmpty
                      ? task.media.first.file
                      : 'https://via.placeholder.com/400x200', // Fallback or placeholder
                  title: task.title,
                  postId: 'TL-${task.id.substring(0, 8)}', // Display ID segment
                ),

                const SizedBox(height: 24),

                // Payment Breakdown
                PaymentBreakdown(
                  isDark: isDark,
                  taskPrice: '\$${amount.toStringAsFixed(2)}',
                  serviceFee: '\$${serviceFee.toStringAsFixed(2)}',
                  total: '\$${total.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 24),

                // Payment Method
                PaymentMethodCard(
                  isDark: isDark,
                  balance: '\$500.00', // Mock balance for now
                  progress: 1.0,
                  usedAmount: '\$${total.toStringAsFixed(2)}',
                  remainingAmount: '\$${(500 - total).toStringAsFixed(2)}',
                ),
              ],
            ),
          ),

          // Sticky Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
              () => PaymentBottomBar(
                isDark: isDark,
                amount: '\$${total.toStringAsFixed(2)}',
                isLoading: controller.isLoading.value,
                onPay: () {
                  controller.processPayment(
                    taskId: task.id,
                    bidId: bid.id,
                    amount: total,
                  );
                },
                onAddFunds: () {
                  // Navigate to Top Up
                  // Get.toNamed(Routes.TOP_UP);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
