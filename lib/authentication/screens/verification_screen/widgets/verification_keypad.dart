import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/controllers/auth/verification_controller.dart';

class VerificationKeypad extends StatelessWidget {
  final VerificationController controller;

  const VerificationKeypad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? Colors.grey[900] : Colors.grey[100],
      padding: const EdgeInsets.only(top: 8, bottom: 32, left: 24, right: 24),
      child: Column(
        children: [
          _buildKeypadRow(controller, ['1', '2', '3'], isDark),
          const SizedBox(height: 16),
          _buildKeypadRow(controller, ['4', '5', '6'], isDark),
           const SizedBox(height: 16),
          _buildKeypadRow(controller, ['7', '8', '9'], isDark),
           const SizedBox(height: 16),
          _buildKeypadRow(controller, ['', '0', 'backspace'], isDark),
        ],
      ),
    );
  }
  
  Widget _buildKeypadRow(VerificationController controller, List<String> keys, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox(width: 100, height: 48); // Spacer
        
        return GestureDetector(
          onTap: () {
            if (key == 'backspace') {
              controller.removeDigit();
            } else {
              controller.addDigit(key);
            }
          },
          child: Container(
            width: 100, // Approx 1/3 minus gap
            height: 48,
            color: Colors.transparent,
            child: Center(
              child: key == 'backspace'
                  ? Icon(Icons.backspace_outlined, color: isDark ? Colors.white : Colors.black, size: 24)
                  : Text(
                      key,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
