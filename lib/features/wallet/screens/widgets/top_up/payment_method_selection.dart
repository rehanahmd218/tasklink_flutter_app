import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/constants/colors.dart';

class PaymentMethodSelection extends StatelessWidget {
  final bool isDark;
  final int selectedPaymentMethod;
  final ValueChanged<int> onPaymentMethodChanged;
  final VoidCallback onManage;

  const PaymentMethodSelection({
    super.key,
    required this.isDark,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Payment Method', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[200] : const Color(0xFF1c1c0d))),
            TextButton(
              onPressed: onManage,
              child: Text('Manage', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? TColors.primary : const Color(0xFF5c5b4f))),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildPaymentOption(
              0,
              Icons.credit_card,
              'Mastercard',
              '•••• 8844',
              isDark,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              1,
              Icons.phone_iphone,
              'Apple Pay',
              'Default',
              isDark,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.grey[600]! : Colors.grey[400]!, style: BorderStyle.solid), // Dashed border replacement for simplicity
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
                      child: Icon(Icons.add, color: isDark ? Colors.grey[400] : Colors.grey[500]),
                    ),
                    const SizedBox(width: 12),
                    Text('Add New Card', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[300] : const Color(0xFF1c1c0d))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(int index, IconData icon, String title, String subtitle, bool isDark) {
    bool isSelected = selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => onPaymentMethodChanged(index),
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
                  Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d))),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f))),
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
