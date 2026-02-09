import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/colors.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ensure value is in items list, otherwise set to null
    final validValue =
        (value != null && value!.isNotEmpty && items.contains(value))
        ? value
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? TColors.darkTextPrimary : TColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? TColors.darkContainer : TColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? TColors.darkBorderPrimary
                  : TColors.borderSecondary,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: validValue,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: GoogleFonts.inter(color: TColors.textSecondary),
                    )
                  : null,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: TColors.textSecondary),
              dropdownColor: isDark ? TColors.darkContainer : TColors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      color: isDark
                          ? TColors.darkTextPrimary
                          : TColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
