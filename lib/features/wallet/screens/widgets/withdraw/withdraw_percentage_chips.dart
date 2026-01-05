import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/constants/colors.dart';

class WithdrawPercentageChips extends StatelessWidget {
  final bool isDark;
  final ValueChanged<double> onPercentageSelected;

  const WithdrawPercentageChips({
    super.key,
    required this.isDark,
    required this.onPercentageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPercentageChip('25%', isDark, 0.25),
          const SizedBox(width: 8),
          _buildPercentageChip('50%', isDark, 0.50),
          const SizedBox(width: 8),
          _buildPercentageChip('75%', isDark, 0.75),
          const SizedBox(width: 8),
          _buildPercentageChip('Max', isDark, 1.00, isMax: true),
        ],
      ),
    );
  }

  Widget _buildPercentageChip(String label, bool isDark, double percentage, {bool isMax = false}) {
    return GestureDetector(
      onTap: () => onPercentageSelected(percentage),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isMax ? TColors.primary.withValues(alpha: 0.1) : (isDark ? const Color(0xFF2d2c15) : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isMax ? TColors.primary.withValues(alpha: 0.2) : (isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce))),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14, 
            fontWeight: isMax ? FontWeight.bold : FontWeight.w600, 
            color: isMax ? (isDark ? TColors.primary : const Color(0xFF1c1c0d)) : (isDark ? Colors.white : const Color(0xFF1c1c0d))
          ),
        ),
      ),
    );
  }
}
