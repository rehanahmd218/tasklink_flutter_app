import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tasklink/controllers/features/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/home_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller already initialized in HomeHeader if we put it there?
    // Better to put it here or rely on Get.put
    // Controller already initialized in HomeHeader if we put it there?
    // Better to put it here or rely on Get.put
    Get.put(HomeController());
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      body: Column(
        children: [
          const HomeHeader(),

          const Expanded(child: HomeListView()),
        ],
      ),
    );
  }
}
