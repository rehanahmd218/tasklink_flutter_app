import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import '../../../../../utils/constants/colors.dart';
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
    // Get task from arguments
    final TaskModel task = Get.arguments as TaskModel;

    final controller = Get.put(BidController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Place Your Bid',
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
