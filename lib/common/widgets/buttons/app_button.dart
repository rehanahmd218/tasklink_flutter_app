import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants/colors.dart';

/// Primary button matching HTML design
/// Height: 56px, rounded-xl (12px), primary background
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final bool showArrow;
  final ButtonType type;
  final double? width;
  final double height;
  final double elevation;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.showArrow = false,
    this.type = ButtonType.primary,
    this.width,
    this.height = 56,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: _backgroundColor(isDark),
        borderRadius: BorderRadius.circular(12),
        elevation: type == ButtonType.primary ? elevation : 0,
        child: InkWell(
          onTap: isEnabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: type == ButtonType.secondary
                  ? Border.all(
                      color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
                      width: 1,
                    )
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(_textColor(isDark)),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: _textColor(isDark),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _textColor(isDark),
                          ),
                        ),
                        if (showArrow) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: _textColor(isDark),
                            size: 20,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(bool isDark) {
    if (!isEnabled) {
      return isDark ? TColors.darkGrey : TColors.grey;
    }

    switch (type) {
      case ButtonType.primary:
        return TColors.primary;
      case ButtonType.secondary:
        return isDark ? TColors.darkContainer : TColors.white;
      case ButtonType.danger:
        return TColors.error;
    }
  }

  Color _textColor(bool isDark) {
    if (!isEnabled) {
      return TColors.textSecondary;
    }

    switch (type) {
      case ButtonType.primary:
        return TColors.textPrimary; // Black on Yellow
      case ButtonType.secondary:
        return isDark ? TColors.darkTextPrimary : TColors.textPrimary;
      case ButtonType.danger:
        return TColors.white;
    }
  }
}

enum ButtonType {
  primary,
  secondary,
  danger,
}

/// Icon button with circular background
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool hasBorder;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: backgroundColor ?? (isDark ? TColors.darkContainer : TColors.white),
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            border: hasBorder
                ? Border.all(
                    color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
                    width: 1,
                  )
                : null,
          ),
          child: Icon(
            icon,
            color: iconColor ?? (isDark ? TColors.darkTextPrimary : TColors.textPrimary),
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
