import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/loaders/empty_state_widget.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/controllers/features/bids/bid_controller.dart';
import 'package:tasklink/features/bids/bids_tasker_view/widgets/my_bid_card.dart';
import 'package:tasklink/models/tasks/bid_model.dart';
import 'package:tasklink/utils/constants/app_colors.dart';
import 'package:tasklink/routes/routes.dart';

class BidsTaskerView extends StatelessWidget {
  const BidsTaskerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BidController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch my bids on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMyBids();
    });

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'My Bids',
        showBackButton: true,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        // ... (body content remains)
        if (controller.isLoadingBids.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.myBids.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.gavel_outlined,
            title: 'No bids placed yet',
            subtitle: 'Start browsing tasks and place your first bid!',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.myBids.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final bid = controller.myBids[index];
            return MyBidCard(
              bid: bid,
              onViewTask: () {
                Get.toNamed(Routes.TASK_DETAILS, arguments: {'taskId': bid.task});
              },
            );
          },
        );
      }),
    );
  }
}
