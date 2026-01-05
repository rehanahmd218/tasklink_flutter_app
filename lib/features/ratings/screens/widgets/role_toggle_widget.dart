import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleToggleWidget extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleToggleWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? TColors.darkContainer : TColors.softGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildTab('As Tasker', 'tasker', isDark),
            _buildTab('As Poster', 'poster', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, String value, bool isDark) {
    final isSelected = selectedRole == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onRoleSelected(value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected 
                ? (isDark ? TColors.darkTextPrimary : Colors.white) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected 
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)] 
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected 
                  ? (isDark ? TColors.backgroundDark : TColors.textPrimary)
                  : TColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

