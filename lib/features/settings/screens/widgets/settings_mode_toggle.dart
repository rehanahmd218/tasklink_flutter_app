import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class SettingsModeToggle extends StatelessWidget {
  final bool isDark;

  const SettingsModeToggle({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: TColors.primary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.swap_horiz, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active Mode', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                    Text('Switch between finding tasks or posting them.', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _buildToggleButton('Tasker', Icons.work, true, isDark)),
                Expanded(child: _buildToggleButton('Poster', Icons.post_add, false, isDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isActive, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? (isDark ? const Color(0xFF2e2d15) : Colors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 2)] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: isActive ? (isDark ? Colors.white : const Color(0xFF1c1c0d)) : Colors.grey),
          const SizedBox(width: 8),
          Text(
            label, 
            style: GoogleFonts.inter(
              fontSize: 14, 
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? (isDark ? Colors.white : const Color(0xFF1c1c0d)) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
