import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/app_colors.dart';

class CircularImage extends StatelessWidget {
  final double width, height, padding;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final BoxFit? fit;

  const CircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.padding = 0,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? AppColors.black : AppColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: fit,
                  color: overlayColor,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const CircularProgressIndicator(), // Simple placeholder for now
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(fit: fit, image: AssetImage(image), color: overlayColor),
        ),
      ),
    );
  }
}
