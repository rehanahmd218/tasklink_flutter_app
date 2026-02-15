import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/app_colors.dart';

class RoundedIcon extends StatelessWidget {
  final double? width, height;
  final double size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final double borderRadius;

  const RoundedIcon({
    super.key,
    this.width,
    this.height,
    this.size = 24,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDark
                ? AppColors.black.withValues(alpha: 0.9)
                : AppColors.white.withValues(alpha: 0.9)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: size),
      ),
    );
  }
}
