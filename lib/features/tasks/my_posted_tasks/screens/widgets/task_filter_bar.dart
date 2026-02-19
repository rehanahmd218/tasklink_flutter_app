import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/controllers/features/tasks/tasks_controller.dart';
import 'package:tasklink/features/tasks/my_posted_tasks/screens/widgets/task_status_filter_sheet.dart';
import 'package:tasklink/utils/constants/colors.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<TasksController>();

    return Obx(() {
      final filter = controller.currentFilter.value;
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
            ),
          ),
        ),
        child: InkWell(
          onTap: () => TaskStatusFilterSheet.show(
            context: context,
            selectedFilter: filter,
            taskCount: controller.filteredTasks.length,
            onApply: (selected) async {
              await controller.applyFilter(selected);
            },
          ),
          child: Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 24,
                color: isDark ? Colors.grey[400] : TColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                filter,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : TColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${controller.filteredTasks.length})',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : TColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: isDark ? Colors.grey[400] : TColors.textSecondary,
              ),
            ],
          ),
        ),
      );
    });
  }
}
