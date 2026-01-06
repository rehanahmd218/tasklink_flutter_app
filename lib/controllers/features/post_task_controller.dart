import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class PostTaskController extends GetxController {
  final title = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController(); // For Map location
  final address = TextEditingController(); // For manual address text
  final estimatedDuration = TextEditingController();
  final budget = TextEditingController();
  
  final selectedCategory = ''.obs;
  final dueDate = Rx<DateTime?>(null);
  
  final images = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> pickImages() async {
    if (images.length >= 3) {
      Get.snackbar('Limit Reached', 'You can only add up to 3 images.');
      return;
    }
    
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        limit: 3 - images.length,
      );
      
      if (pickedFiles.isNotEmpty) {
        images.addAll(pickedFiles);
        // Ensure we don't exceed 3 if the picker didn't respect the limit (older OS support sometimes varies)
        if (images.length > 3) {
          images.value = images.take(3).toList();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }
}
