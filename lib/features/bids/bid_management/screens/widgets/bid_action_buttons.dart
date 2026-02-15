import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/common/widgets/buttons/secondary_button.dart';

class BidActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onContact;
  final VoidCallback onWithdraw;

  const BidActionButtons({
    super.key,
    required this.onEdit,
    required this.onContact,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        PrimaryButton(
          onPressed: onEdit,
          text: 'Edit Bid',
          icon: Icons.edit,
          borderRadius: 30,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          onPressed: onContact,
          text: 'Contact Poster',
          icon: Icons.chat_bubble_outline,
          borderRadius: 30,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onWithdraw,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text('Withdraw Bid', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
