import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpQuickAddChips extends StatelessWidget {
  final bool isDark;
  final ValueChanged<String> onAmountSelected;

  const TopUpQuickAddChips({
    super.key,
    required this.isDark,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildQuickAddChip('+\$10', isDark),
          const SizedBox(width: 8),
          _buildQuickAddChip('+\$25', isDark),
          const SizedBox(width: 8),
          _buildQuickAddChip('+\$50', isDark),
          const SizedBox(width: 8),
          _buildQuickAddChip('+\$100', isDark),
        ],
      ),
    );
  }

  Widget _buildQuickAddChip(String label, bool isDark) {
    return GestureDetector(
      onTap: () {
        String value = label.replaceAll('+\$', '');
        onAmountSelected(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2d2c15) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF1c1c0d)),
        ),
      ),
    );
  }
}
