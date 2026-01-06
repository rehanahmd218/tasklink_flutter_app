import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/controllers/features/post_task_controller.dart';
import 'package:tasklink/utils/constants/colors.dart';

class PostTaskMediaScreen extends StatelessWidget {
  const PostTaskMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the existing controller
    final controller = Get.find<PostTaskController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Task Media',
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: Text('Back', style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.grey[600])),
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
                  Text('Add Photos', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 8),
                  Text('Help Taskers understand your task better by adding up to 3 photos.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                  const SizedBox(height: 24),

                  // Media Upload Section
                  Obx(() => Row(
                    children: [
                      // Add Button
                      if (controller.images.length < 3)
                        GestureDetector(
                          onTap: controller.pickImages,
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF27272A) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!, style: BorderStyle.solid),
                            ),
                            child: Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[500]),
                          ),
                        ),
                      
                      // Image List
                      ...controller.images.asMap().entries.map((entry) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(File(entry.value.path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.removeImage(entry.key),
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  )),
                  
                  if (controller.images.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('No photos added yet.', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
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
                // Logic to actually post the task would go here
                print('Post Task Clicked'); 
                Get.back(); // Temporary behavior until actual post logic is integrated
                Get.snackbar('Success', 'Task Posted Successfully (Mock)');
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
