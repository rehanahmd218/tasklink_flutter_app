import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/post_task/widgets/post_task_category_selector.dart';
import 'package:tasklink/features/post_task/widgets/post_task_date_budget_row.dart';
import 'package:tasklink/features/post_task/widgets/post_task_info_tip.dart';
import 'package:tasklink/features/post_task/widgets/post_task_location_input.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/post_task_controller.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';
import 'package:tasklink/routes/routes.dart';

class PostTaskScreen extends StatelessWidget {
  const PostTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostTaskController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'New Task',
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.grey[600])),
        ),
      ),
      body: Column(
        children: [

          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Headline
                   Padding(
                     padding: const EdgeInsets.all(20),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('What needs to be done?', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                         const SizedBox(height: 4),
                         Text('Provide details so Taskers can give you accurate offers.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                       ],
                     ),
                   ),
                   
                   // Title Input
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: AppTextField(
                       label: 'Task Title',
                       hint: 'e.g., Assemble IKEA furniture',
                       controller: controller.title,
                     ),
                   ),
                   
                   // Description
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: AppTextField(
                       label: 'Description',
                       hint: 'Describe the task in detail. Mention any tools required...',
                       controller: controller.description,
                       maxLines: 4,
                     ),
                   ),
                   
                   const SizedBox(height: 12),
                   
                   // Category
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: PostTaskCategorySelector(controller: controller),
                   ),
                   
                   const SizedBox(height: 12),
                   
                   // Location (Map Selection)
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: PostTaskLocationInput(controller: controller),
                   ),

                   // Address (Text Input)
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: AppTextField(
                       label: 'Address',
                       hint: 'Enter full address',
                       controller: controller.address,
                     ),
                   ),

                   // Estimated Duration
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: AppTextField(
                       label: 'Estimated Duration',
                       hint: 'e.g., 2 hours, 1 day',
                       controller: controller.estimatedDuration,
                     ),
                   ),
                   
                   const SizedBox(height: 12),
                   
                   // Details Grid (Due Date, Budget)
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: PostTaskDateBudgetRow(controller: controller),
                   ),
                   


                   // Info
                   const Padding(
                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                     child: PostTaskInfoTip(),
                   ),
                ],
              ),
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? TColors.backgroundDark : Colors.white,
              border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
            ),
            child: PrimaryButton(
              onPressed: () {
                // Navigate to Media Screen
                Get.toNamed(Routes.POST_TASK_MEDIA);
              },
              text: 'Next',
              icon: Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }

}
