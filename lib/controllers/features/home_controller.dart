import 'package:get/get.dart';

class HomeController extends GetxController {
  final isMapView = true.obs;

  void toggleViewMode(bool isMap) {
    isMapView.value = isMap;
  }
}
