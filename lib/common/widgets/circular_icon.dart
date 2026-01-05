import 'package:flutter/material.dart';
class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double? iconSize;
  final VoidCallback? onPressed;
  const CircularIcon({
    super.key,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.size = 40,
    this.iconSize,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
          size: iconSize ?? size / 2,
        ),
      ),
    );
  }
}