import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/loaders/empty_state_widget.dart';
import 'package:tasklink/controllers/features/home_controller.dart';
import 'package:tasklink/features/home/widgets/home_task_card.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/routes/routes.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'home_filter_bar.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(HomeController());

    return RefreshIndicator(
      onRefresh: controller.fetchNearbyTasks,
      color: TColors.primary,
      child: Column(
        children: [
          // Filter Chips
          const HomeFilterBar(),

          // List Header and Task List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: TColors.primary),
                );
              }

              final tasks = controller.filteredTasks;

              if (tasks.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: EmptyStateWidget(
                            icon: Icons.inbox_outlined,
                            title: 'No tasks found',
                            subtitle:
                                'No tasks found nearby. Pull down to refresh.',
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${tasks.length} Tasks nearby',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Sort by: Distance',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[500],
                              ),
                            ),
                            Icon(
                              Icons.expand_more,
                              size: 18,
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return HomeTaskCard(
                          task: task,
                          onTap: () => _navigateToDetails(task),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(TaskModel task) {
    Get.toNamed(Routes.TASK_DETAILS, arguments: {'taskId': task.id});
  }
}
