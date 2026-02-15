import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/app_colors.dart';
import 'package:tasklink/theme/text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: AppTextStyles.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.grey,
        disabledBackgroundColor: AppColors.grey,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.black, size: 24),
      actionsIconTheme: IconThemeData(color: AppColors.black, size: 24),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: AppTextStyles.darkTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.grey,
        disabledBackgroundColor: AppColors.darkGrey,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white, size: 24),
      actionsIconTheme: IconThemeData(color: AppColors.white, size: 24),
    ),
  );
}
