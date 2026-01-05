import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/auth/reset_password_controller.dart';

class ResetOtpSection extends StatelessWidget {
  final ResetPasswordController controller;

  const ResetOtpSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VERIFICATION CODE',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: TColors.textSecondary,
            letterSpacing: 1.0, 
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => SizedBox(
            width: 45, // max-w-[3rem] approx
            height: 48,
            child: TextField(
              controller: controller.otpControllers[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                 counterText: "",
                 contentPadding: EdgeInsets.zero,
                 filled: true,
                 fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey[300]!)),
                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey[300]!)),
                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: TColors.primary, width: 2)),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
              },
            ),
          )),
        ),
        
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Resend code in 00:45',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: TColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
