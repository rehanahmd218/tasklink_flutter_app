import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/constants/colors.dart';

class PayoutMethodSelection extends StatelessWidget {
  final bool isDark;
  final int selectedPayoutMethod;
  final ValueChanged<int> onPayoutMethodChanged;
  final VoidCallback onManage;

  const PayoutMethodSelection({
    super.key,
    required this.isDark,
    required this.selectedPayoutMethod,
    required this.onPayoutMethodChanged,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Payout Method', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[200] : const Color(0xFF1c1c0d))),
            TextButton(
              onPressed: onManage,
              child: Text('Manage', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? TColors.primary : const Color(0xFF5c5b4f))),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildPayoutOption(
              0,
              Icons.account_balance,
              'Chase Bank',
              'Checking •••• 8844',
              'Arrives in 1-3 business days',
              isDark,
            ),
            const SizedBox(height: 12),
            _buildPayoutOption(
              1,
              Icons.credit_card,
              'Visa Debit',
              '•••• 4242',
              '1.5% fee applies',
              isDark,
              isInstant: true,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.grey[600]! : Colors.grey[400]!, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add_card, color: isDark ? Colors.grey[400] : Colors.grey[500]),
                    ),
                    const SizedBox(width: 12),
                    Text('Add Payout Method', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[300] : const Color(0xFF1c1c0d))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayoutOption(int index, IconData icon, String title, String subtitle, String footer, bool isDark, {bool isInstant = false}) {
    bool isSelected = selectedPayoutMethod == index;
    return GestureDetector(
      onTap: () => onPayoutMethodChanged(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2d2c15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? TColors.primary : (isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce)), width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: index == 1 ? Colors.black : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: index == 1 ? Colors.white : Colors.grey[800]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                      if (isInstant) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(4)),
                          child: Text('INSTANT', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.yellow[800])),
                        ),
                      ],
                    ],
                  ),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f))),
                  Text(footer, style: GoogleFonts.inter(fontSize: 10, color: isInstant ? (isDark ? Colors.grey[500] : const Color(0xFF5c5b4f)) : Colors.green)),
                ],
              ),
            ),
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? TColors.primary : Colors.grey[400]!, width: 2),
                color: isSelected ? TColors.primary : Colors.transparent,
              ),
              child: isSelected ? const Center(child:  Icon(Icons.check, size: 14, color: Colors.black)) : null,
            ),
          ],
        ),
      ),
    );
  }
}
