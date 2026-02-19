import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/common/widgets/media_picker_section.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/utils/constants/colors.dart';

class PostTaskMediaScreen extends StatelessWidget {
  const PostTaskMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the existing controller
    final controller = Get.find<PostTaskController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Task Media',
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Back',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => MediaPickerSection(
                      title: 'Add Photos',
                      subtitle: 'Help Taskers understand your task better by adding up to 3 photos.',
                      images: controller.images,
                      maxFiles: 3,
                      onAddRequest: controller.pickImages,
                      onRemove: controller.removeImage,
                    ),
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
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: PrimaryButton(
              onPressed: () {
                // Logic to actually post the task would go here
                print('Post Task Clicked');
                Get.back(); // Temporary behavior until actual post logic is integrated
                StatusSnackbar.showSuccess(message: 'Task posted successfully (placeholder)'); // Placeholder success message            
              },
              text: 'Post Task',
              icon: Icons.check,
            ),
          ),
        ],
      ),
    );
  }
}
