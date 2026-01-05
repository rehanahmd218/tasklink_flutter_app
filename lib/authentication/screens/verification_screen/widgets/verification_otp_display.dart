import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/auth/verification_controller.dart';

class VerificationOtpDisplay extends StatelessWidget {
  final VerificationController controller;

  const VerificationOtpDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        String char = index < controller.otp.value.length ? controller.otp.value[index] : '';
        bool isFocused = index == controller.otp.value.length;
        return Container(
          width: 48,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isFocused 
                  ? TColors.primary 
                  : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
              width: isFocused ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              char,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : TColors.textPrimary,
              ),
            ),
          ),
        );
      }),
    ));
  }
}
