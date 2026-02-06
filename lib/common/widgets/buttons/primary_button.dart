import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double width;
  final double height;
  final double borderRadius;
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 12,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? TColors.primary,
          foregroundColor: foregroundColor ?? Colors.black,
          padding: EdgeInsets.symmetric(vertical: (height - 24) / 2), // Approximate centering
          minimumSize: Size(width, height),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          elevation: 4,
          shadowColor: TColors.primary.withValues(alpha: 0.2),
          textStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}