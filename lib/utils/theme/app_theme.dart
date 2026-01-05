import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.backgroundLight,
    colorScheme: const ColorScheme.light(
        primary: TColors.primary,
        secondary: TColors.primary,
        surface: TColors.white,
        onPrimary: TColors.backgroundDark, // Text on primary button is dark
    ),
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: TColors.textPrimary,
      displayColor: TColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: TColors.backgroundLight.withValues(alpha: 0.95),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: TColors.textPrimary),
        titleTextStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: TColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primary,
        foregroundColor: TColors.backgroundDark,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: TColors.borderSecondary)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: TColors.borderSecondary)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: TColors.primary)
        ),
        hintStyle: const TextStyle(color: TColors.textSecondary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.backgroundDark,
     colorScheme: const ColorScheme.dark(
        primary: TColors.primary,
        secondary: TColors.primary,
        surface: TColors.darkContainer,
        onPrimary: TColors.backgroundDark,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: TColors.darkTextPrimary,
      displayColor: TColors.darkTextPrimary,
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: TColors.backgroundDark.withValues(alpha: 0.95),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: TColors.darkTextPrimary),
        titleTextStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: TColors.darkTextPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primary,
        foregroundColor: TColors.backgroundDark,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TColors.darkContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: TColors.darkBorderPrimary)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: TColors.darkBorderPrimary)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: TColors.primary)
        ),
        hintStyle: const TextStyle(color: TColors.darkTextSecondary),
    ),
  );
}
