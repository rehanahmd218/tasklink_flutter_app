import 'package:get/get.dart';
import 'package:tasklink/controllers/location/location_controller.dart';
import 'package:tasklink/controllers/user_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController(), permanent: true);
    Get.put(LocationController(), permanent: true);
  }
}
