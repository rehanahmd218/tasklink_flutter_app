import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/utils/validators/form_validators.dart';

import 'package:tasklink/common/widgets/app_text_field.dart';

class PostTaskDateBudgetRow extends StatelessWidget {
  final PostTaskController controller;

  const PostTaskDateBudgetRow({super.key, required this.controller});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.dueDate.value ?? now,
      firstDate: now, // Minimum date is today
      lastDate: DateTime(now.year + 1), // Max 1 year from now
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColors.primary,
              onPrimary: Colors.black,
              surface: isDark ? const Color(0xFF27272A) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.dueDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due Date',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF27272A)
                              : Colors.white,
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[200]!,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.dueDate.value != null
                                    ? DateFormat(
                                        'EEE, MMM d',
                                      ).format(controller.dueDate.value!)
                                    : 'Select date',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: controller.dueDate.value != null
                                      ? (isDark ? Colors.white : Colors.black)
                                      : Colors.grey[500],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.expand_more, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Budget',
                hint: 'Enter amount',
                controller: controller.budget,
                keyboardType: TextInputType.number,
                validator: FormValidators.validateBudget,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
