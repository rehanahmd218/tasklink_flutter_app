import 'package:flutter/material.dart';
import 'package:tasklink/theme/app_colors.dart';

class CircularContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool showBorder;
  final VoidCallback? onTap;

  const CircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.child,
    this.backgroundColor,
    this.borderColor,
    this.showBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color:
              backgroundColor ?? (isDark ? AppColors.black : AppColors.white),
          border: showBorder
              ? Border.all(color: borderColor ?? AppColors.borderPrimary)
              : null,
        ),
        child: child,
      ),
    );
  }
}
