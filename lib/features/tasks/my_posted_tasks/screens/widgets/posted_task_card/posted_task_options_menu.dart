import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostedTaskOptionsMenu extends StatelessWidget {
  final bool isDark;
  /// When false, Edit and Delete are disabled (e.g. task not in POSTED/BIDDING).
  final bool canEdit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PostedTaskOptionsMenu({
    super.key,
    required this.isDark,
    this.canEdit = true,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        color: canEdit ? Colors.grey : Colors.grey.withValues(alpha: 0.5),
      ),
      onSelected: (value) {
        if (!canEdit) return;
        if (value == 'edit' && onEdit != null) {
          onEdit!();
        } else if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          enabled: canEdit,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          enabled: canEdit,
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
