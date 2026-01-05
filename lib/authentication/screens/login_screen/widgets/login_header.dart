import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Container(
          width: 96, // w-24 (24 * 4)
          height: 96, // h-24
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF292524) : Colors.white, // bg-white dark:bg-stone-800
            borderRadius: BorderRadius.circular(16), // rounded-2xl
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), // shadow-sm
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.handshake_outlined,
              size: 48, // text-5xl
              color: TColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 24), // mb-6
        Text(
          'Welcome Back!',
          style: GoogleFonts.inter(
            fontSize: 30, // text-3xl
            fontWeight: FontWeight.bold,
            color: isDark ? TColors.darkTextPrimary : TColors.textPrimary,
            letterSpacing: -0.025, // tracking-tight
          ),
        ),
        const SizedBox(height: 8), // mt-2
        Text(
          'Please sign in to continue to TaskLink',
          style: GoogleFonts.inter(
            fontSize: 14, // text-sm
            color: isDark ? TColors.darkTextSecondary : TColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32), // mb-8
      ],
    );
  }
}
