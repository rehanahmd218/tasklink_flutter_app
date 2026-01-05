import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/colors.dart';

class ReviewTraitsSelection extends StatelessWidget {
  final bool isDark;
  final List<String> allTraits;
  final List<String> selectedTraits;
  final ValueChanged<String> onTraitToggle;

  const ReviewTraitsSelection({
    super.key,
    required this.isDark,
    required this.allTraits,
    required this.selectedTraits,
    required this.onTraitToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WHAT WENT WELL?', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allTraits.map((trait) {
              bool isSelected = selectedTraits.contains(trait);
              return GestureDetector(
                onTap: () => onTraitToggle(trait),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? TColors.primary : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? TColors.primary : (isDark ? Colors.grey[700]! : Colors.grey[200]!)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected && trait == 'Punctual') const Icon(Icons.schedule, size: 16, color: Colors.black),
                      if (isSelected && trait == 'Friendly') const Icon(Icons.sentiment_satisfied, size: 16, color: Colors.black),
                      if (isSelected) const SizedBox(width: 8),
                      Text(
                        trait,
                        style: GoogleFonts.inter(
                          fontSize: 14, 
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.black : (isDark ? Colors.grey[300] : Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
