import 'package:get/get.dart';

class HomeController extends GetxController {
  final isMapView = true.obs;

  void toggleViewMode(bool isMap) {
    isMapView.value = isMap;
  }

  // Radius Filter (0 means "Any" or max 30km as per requirement)
  final radius = 30.obs;

  void updateRadius(int newRadius) {
    radius.value = newRadius;
  }
}
