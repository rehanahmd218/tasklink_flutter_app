import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final bool value;
  final bool isDark;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.isDark,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
           Container(
             width: 40, height: 40,
             decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
             child: Icon(icon, color: Colors.black, size: 20),
           ),
           const SizedBox(width: 16),
           Expanded(
             child: Text(
               title,
               style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: isDark ? Colors.white : const Color(0xFF1c1c0d)),
             ),
           ),
           Switch(
             value: value,
             onChanged: onChanged ?? (val) {},
             activeThumbColor: TColors.primary,
             activeTrackColor: TColors.primary.withValues(alpha: 0.5),
           ),
        ],
      ),
    );
  }
}
