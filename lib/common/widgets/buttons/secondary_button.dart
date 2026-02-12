import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final double width;
  final double height;
  final double borderRadius;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 12,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.fontSize,
    this.padding,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Default colors
    final defaultFg = isDark ? Colors.white : Colors.black;
    final defaultBorder = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? defaultFg,
          backgroundColor: backgroundColor ?? Colors.transparent,
          side: BorderSide(color: borderColor ?? defaultBorder),
          padding:
              padding ??
              EdgeInsets.symmetric(vertical: (height - 24) / 2, horizontal: 12),
          minimumSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(text),
          ],
        ),
      ),
    );
  }
}
