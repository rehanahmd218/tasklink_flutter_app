import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/home_map_view.dart';
import '../widgets/home_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller already initialized in HomeHeader if we put it there? 
    // Better to put it here or rely on Get.put
    final controller = Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: Obx(() => controller.isMapView.value 
              ? const HomeMapView() 
              : const HomeListView()
            ),
          ),
        ],
      ),
    );
  }
}
