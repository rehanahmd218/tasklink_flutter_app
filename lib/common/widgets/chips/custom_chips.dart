import 'package:flutter/material.dart';
import 'package:tasklink/utils/constants/colors.dart';

class ThemedChip extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  const ThemedChip({
    super.key,
    required this.text,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FilterChip(
      label: Text(text),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: isDark
          ? TColors.darkContainer
          : TColors.lightContainer,
      selectedColor: TColors.primary,
      checkmarkColor: TColors.black,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: selected
            ? TColors.black
            : (isDark ? TColors.white : TColors.black),
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: selected
              ? TColors.primary
              : (isDark
                    ? TColors.darkBorderPrimary
                    : TColors.borderPrimary),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const StatusChip({
    super.key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
