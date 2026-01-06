import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/routes/app_pages.dart';
import 'package:tasklink/routes/routes.dart';
import 'utils/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TaskLink',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.LOGIN,
      getPages:AppPages.routes,
    );
  }
}
