import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final bool isDark;
  final bool isCrimson;
  final bool showExternalIcon;
  final VoidCallback onTap;

  const SettingsListTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.title,
    this.subtitle,
    required this.isDark,
    required this.onTap,
    this.isCrimson = false,
    this.showExternalIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = isCrimson ? Colors.red : Colors.black;
    Color? bg = isCrimson
        ? (isDark ? Colors.red.withValues(alpha: 0.2) : Colors.red[100])
        : (iconBg == TColors.primary ? TColors.primary : iconBg);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isCrimson
                          ? Colors.red
                          : (isDark ? Colors.white : const Color(0xFF1c1c0d)),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              showExternalIcon ? Icons.open_in_new : Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
