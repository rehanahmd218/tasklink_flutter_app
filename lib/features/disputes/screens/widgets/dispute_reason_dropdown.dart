import 'package:flutter/material.dart';
import 'package:tasklink/common/widgets/app_dropdown.dart';
class DisputeReasonDropdown extends StatelessWidget {
  final String? selectedReason;
  final List<String> reasons;
  final ValueChanged<String?> onChanged;

  const DisputeReasonDropdown({
    super.key,
    required this.selectedReason,
    required this.reasons,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdown(
      label: 'Reason for Dispute',
      value: selectedReason,
      items: reasons,
      onChanged: onChanged,
      hint: 'Select a reason...',
    );
  }
}
