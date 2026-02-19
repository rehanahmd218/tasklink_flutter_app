import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/colors.dart';
import 'package:tasklink/theme/text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.backgroundLight,
    textTheme: AppTextStyles.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: TColors.textPrimary,
        backgroundColor: TColors.primary,
        disabledForegroundColor: TColors.grey,
        disabledBackgroundColor: TColors.grey,
        side: const BorderSide(color: TColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 16,
          color: TColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: TColors.backgroundLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: TColors.black, size: 24),
      actionsIconTheme: IconThemeData(color: TColors.black, size: 24),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.backgroundDark,
    textTheme: AppTextStyles.darkTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: TColors.textPrimary,
        backgroundColor: TColors.primary,
        disabledForegroundColor: TColors.grey,
        disabledBackgroundColor: TColors.darkGrey,
        side: const BorderSide(color: TColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 16,
          color: TColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: TColors.backgroundDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: TColors.white, size: 24),
      actionsIconTheme: IconThemeData(color: TColors.white, size: 24),
    ),
  );
}
