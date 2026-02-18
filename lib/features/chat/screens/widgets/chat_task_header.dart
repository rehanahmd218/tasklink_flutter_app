import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/models/chat/chat_room_model.dart';
import 'package:tasklink/routes/routes.dart';
import '../../../../utils/constants/colors.dart';

/// Header showing active tasks for this chat (stacked). One room per user-pair.
class ChatTaskHeader extends StatelessWidget {
  /// Legacy single task name when no active tasks.
  final String taskName;
  /// Active tasks from room payload (stacked).
  final List<ChatRoomActiveTask> activeTasks;

  const ChatTaskHeader({
    super.key,
    this.taskName = '',
    this.activeTasks = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasStacked = activeTasks.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2d2d1e) : const Color(0xFFf4f4e6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasStacked ? _buildStackedTasks(context, isDark) : _buildSingleTask(context, isDark),
      ),
    );
  }

  Widget _buildSingleTask(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: TColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.task_alt, size: 18, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENT TASK',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                taskName.isEmpty ? 'No active task' : taskName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStackedTasks(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ACTIVE TASKS (${activeTasks.length})',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: activeTasks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final t = activeTasks[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.TASK_DETAILS, arguments: {'taskId': t.id}),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: TColors.primary.withValues(alpha: isDark ? 0.25 : 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: TColors.primary.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.task_alt, size: 16, color: Colors.black87),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            t.title,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
