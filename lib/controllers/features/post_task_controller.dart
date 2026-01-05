import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostTaskController extends GetxController {
  final title = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();
  final budget = TextEditingController();
  
  final selectedCategory = ''.obs;
  final dueDate = Rx<DateTime?>(null);

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
