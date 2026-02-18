import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/circular_icon.dart';
import 'widgets/bid_amount_input.dart';
import 'widgets/bid_context_card.dart';
import 'widgets/bid_pitch_input.dart';
import 'widgets/bid_summary_footer.dart';

class PlaceBidScreen extends StatelessWidget {
  const PlaceBidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Handle arguments for Edit/Place mode
    final args = Get.arguments;
    late final TaskModel task;
    final controller = Get.put(BidController());

    if (args is Map && args.containsKey('task') && args.containsKey('bid')) {
      task = args['task'];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.initializeForEdit(args['bid']);
      });
    } else {
      task = args is TaskModel
          ? args
          : TaskModel(
              id: '',
              title: '',
              description: '',
              category: '',
              budget: 0,
              status: '',
              paymentVerified: false,
              addressText: '',
              radius: 0,
              createdAt: DateTime.now(),
            ); // Fallback

      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.isEdit.value = false;
        controller.bidId = null;
        controller.amountController.clear();
        controller.messageController.clear();
        controller.rxBidAmount.value = 0.0;
      });
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Obx(
          () => PrimaryAppBar(
            title: controller.isEdit.value ? 'Edit Your Bid' : 'Place Your Bid',
            showBackButton: false,
            leading: CircularIcon(
              icon: Icons.close,
              onPressed: () => Get.back(),
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              color: isDark ? Colors.white : Colors.black,
              size: 40,
              iconSize: 20,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // AppBar
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BidContextCard(task: task),

                    const SizedBox(height: 32),

                    BidAmountInput(controller: controller),

                    const SizedBox(height: 32),

                    BidPitchInput(controller: controller),
                  ],
                ),
              ),
            ),
          ),

          // Footer
          BidSummaryFooter(controller: controller, taskId: task.id),
        ],
      ),
    );
  }
}
