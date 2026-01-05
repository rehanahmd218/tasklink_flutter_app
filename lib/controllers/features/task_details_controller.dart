import 'package:get/get.dart';

enum TaskRole { poster, tasker }

class TaskDetailsController extends GetxController {
  final userRole = Rx<TaskRole>(TaskRole.tasker); // Default to tasker for demo of 'Find Work' flow

  void setRole(TaskRole role) {
    userRole.value = role;
  }
}
