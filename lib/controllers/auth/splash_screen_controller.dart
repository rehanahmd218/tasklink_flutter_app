import 'package:get/get.dart';

import 'package:tasklink/routes/routes.dart';



class SplashScreenController extends GetxController {

  @override
  void onReady() async {
    super.onReady();
 
    // Initial splash delay
    await Future.delayed(const Duration(seconds: 3));

    for (final route in Routes.all) {
      // print('Navigating to: $route');

      Get.offAllNamed(route);
      
      // Wait 10 seconds before next screen
      await Future.delayed(const Duration(seconds: 4));
    }
  }
}
