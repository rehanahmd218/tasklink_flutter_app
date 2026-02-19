import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants/colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: TColors.textPrimary,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: TColors.textPrimary,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: TColors.textPrimary,
    ),

    headlineMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: TColors.textPrimary,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: TColors.textPrimary,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: TColors.textPrimary,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: TColors.textPrimary,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: TColors.textPrimary,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: TColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: TColors.textPrimary,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: TColors.textPrimary.withValues(alpha: 0.5),
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.textPrimary,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.textPrimary.withValues(alpha: 0.5),
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: TColors.darkTextPrimary,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: TColors.darkTextPrimary,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: TColors.darkTextPrimary,
    ),

    headlineMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: TColors.darkTextPrimary,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: TColors.darkTextPrimary,
    ),

    titleLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: TColors.darkTextPrimary,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: TColors.darkTextPrimary,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: TColors.darkTextPrimary,
    ),

    bodyLarge: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: TColors.darkTextPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: TColors.darkTextPrimary,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: TColors.darkTextPrimary.withValues(alpha: 0.5),
    ),

    labelLarge: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.darkTextPrimary,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.darkTextPrimary.withValues(alpha: 0.5),
    ),
  );
}
