import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Card widget matching HTML design
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? TColors.darkContainer : TColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Avatar widget with optional online indicator
class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final String? initials;
  final double size;
  final bool showOnlineIndicator;
  final bool isOnline;
  final bool showVerified;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.imagePath,
    this.initials,
    this.size = 48,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.showVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? TColors.darkBorderPrimary : TColors.borderPrimary,
              width: 2,
            ),
            color: isDark ? TColors.darkBorderPrimary : TColors.grey,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: _buildImage(),
          ),
        ),
        if (showOnlineIndicator)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: isOnline ? TColors.success : TColors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? TColors.darkContainer : Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        if (showVerified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isDark ? TColors.darkContainer : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.verified,
                color: TColors.success,
                size: size * 0.3,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImage() {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) => _buildInitials(),
      );
    } else if (imagePath != null) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) => _buildInitials(),
      );
    } else {
      return _buildInitials();
    }
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        initials ?? '?',
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: TColors.textSecondary,
        ),
      ),
    );
  }
}

/// Chip/Tag widget matching HTML design
class ChipWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback? onTap;

  const ChipWidget({
    super.key,
    required this.label,
    this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? TColors.primary
                : (isDark ? TColors.darkContainer : Colors.white),
            borderRadius: BorderRadius.circular(100),
            border: isActive
                ? null
                : Border.all(
                    color: isDark ? TColors.darkBorderPrimary : TColors.borderSecondary,
                    width: 1,
                  ),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: isActive
                      ? TColors.textPrimary
                      : (isDark ? TColors.darkTextSecondary : TColors.textSecondary),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isActive
                      ? TColors.textPrimary
                      : (isDark ? TColors.darkTextSecondary : TColors.textSecondary),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rating stars widget
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showValue;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(
              Icons.star,
              size: size,
              color: color ?? TColors.primary,
            );
          } else if (index < rating) {
            return Icon(
              Icons.star_half,
              size: size,
              color: color ?? TColors.primary,
            );
          } else {
            return Icon(
              Icons.star_border,
              size: size,
              color: TColors.grey,
            );
          }
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: size, // Match icon size approx
            ),
          ),
        ],
      ],
    );
  }
}

