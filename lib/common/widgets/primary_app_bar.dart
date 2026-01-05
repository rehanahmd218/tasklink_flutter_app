import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  const PrimaryAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.leading,
    this.leadingWidth,
    this.actions,
    this.bottom,
    this.centerTitle = true,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      leading: leading ?? (showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : const Color(0xFF1c1c0d)),
              onPressed: () => Get.back(),
            )
          : null),
      leadingWidth: leadingWidth,
      title: titleWidget ?? Text(
        title ?? '',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: isDark ? Colors.white : const Color(0xFF1c1c0d),
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: (isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5)).withValues(alpha: 0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      bottom: bottom != null ? PreferredSize(
        preferredSize: Size.fromHeight(bottom!.preferredSize.height + 1),
        child: Column(
          children: [
            bottom!,
            Container(
              color: isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce),
              height: 1,
            ),
          ],
        ),
      ) : null,
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 1));
}