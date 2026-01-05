import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpAmountInput extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;

  const TopUpAmountInput({
    super.key,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter Amount', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[200] : const Color(0xFF1c1c0d))),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2d2c15) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? const Color(0xFF3e3d24) : const Color(0xFFe9e8ce)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1c1c0d)),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('\$', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : const Color(0xFF5c5b4f))),
              ),
              hintText: '0.00',
              hintStyle: GoogleFonts.inter(color: isDark ? Colors.grey[600] : Colors.grey[300]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
          ),
        ),
      ],
    );
  }
}
