import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    headlineMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary.withValues(alpha: 0.5),
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary.withValues(alpha: 0.5),
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: AppColors.darkTextPrimary,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),

    headlineMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextPrimary,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextPrimary,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextPrimary,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextPrimary.withValues(alpha: 0.5),
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextPrimary,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextPrimary.withValues(alpha: 0.5),
    ),
  );
}
