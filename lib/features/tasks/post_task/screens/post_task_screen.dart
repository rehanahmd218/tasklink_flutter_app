import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/features/tasks/post_task/widgets/post_task_category_selector.dart';
import 'package:tasklink/features/tasks/post_task/widgets/post_task_date_budget_row.dart';
import 'package:tasklink/features/tasks/post_task/widgets/post_task_info_tip.dart';
import 'package:tasklink/features/tasks/post_task/widgets/post_task_location_input.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/tasks/post_task_controller.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';
import 'package:tasklink/utils/validators/form_validators.dart';

class PostTaskScreen extends StatelessWidget {
  const PostTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostTaskController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: controller.isEdit.value ? 'Edit Task' : 'New Task',
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Headline
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.isEdit.value
                                  ? 'Edit Task Details'
                                  : 'What needs to be done?',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Provide details so Taskers can give you accurate offers.',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Title Input
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: AppTextField(
                          label: 'Task Title',
                          hint: 'e.g., Assemble IKEA furniture',
                          controller: controller.title,
                          validator: FormValidators.validateTaskTitle,
                        ),
                      ),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: AppTextField(
                          label: 'Description',
                          hint:
                              'Describe the task in detail. Mention any tools required...',
                          controller: controller.description,
                          maxLines: 4,
                          validator: FormValidators.validateTaskDescription,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Category
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: PostTaskCategorySelector(controller: controller),
                      ),

                      const SizedBox(height: 12),

                      // Location (Map Selection)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: PostTaskLocationInput(controller: controller),
                      ),

                      // Address (Text Input - Read Only)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: AppTextField(
                          label: 'Address',
                          hint: 'Select location to auto-fill address',
                          controller: controller.address,
                          enabled: false, // Read-only, filled by map selection
                          validator: (value) =>
                              FormValidators.validateRequired(value, 'Address'),
                        ),
                      ),

                      // Radius
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: AppTextField(
                          label: 'Visibility Radius (km)',
                          hint:
                              'How far should taskers see your task? (1-50 km)',
                          controller: controller.radius,
                          keyboardType: TextInputType.number,
                          validator: FormValidators.validateRadius,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Details Grid (Due Date, Budget)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: PostTaskDateBudgetRow(controller: controller),
                      ),

                      const SizedBox(height: 12),

                      // Media Upload Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Photos (Optional)',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add up to 3 photos to help taskers understand your task better',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Obx(() {
                              final totalMedia =
                                  controller.existingMedia.length +
                                  controller.images.length;
                              return totalMedia == 0
                                  ? GestureDetector(
                                      onTap: controller.pickImages,
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[400]!,
                                            width: 1.5,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: isDark
                                              ? Colors.grey[900]
                                              : Colors.grey[100],
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                size: 40,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Add Photos',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                      itemCount:
                                          totalMedia + (totalMedia < 3 ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        // Existing Images
                                        if (index <
                                            controller.existingMedia.length) {
                                          return Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  controller
                                                      .existingMedia[index].file,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Container(
                                                        color: Colors.grey[200],
                                                        child: const Icon(
                                                          Icons.error,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .removeExistingImage(
                                                        index,
                                                      ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        // New Images
                                        else if (index < totalMedia) {
                                          final fileIndex =
                                              index -
                                              controller.existingMedia.length;
                                          return Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  File(
                                                    controller
                                                        .images[fileIndex]
                                                        .path,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .removeImage(fileIndex),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        // Add Button
                                        else {
                                          return GestureDetector(
                                            onTap: controller.pickImages,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey[400]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: isDark
                                                    ? Colors.grey[900]
                                                    : Colors.grey[100],
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 32,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Info
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: PostTaskInfoTip(),
                      ),
                    ],
                  ),
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
                onPressed: controller.submitTask,
                text: controller.isEdit.value ? 'Update Task' : 'Post Task',
                icon: controller.isEdit.value ? Icons.save : Icons.upload,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
