import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/auth/splash_screen_controller.dart';








class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashScreenController());
    return Scaffold(
      backgroundColor: TColors.primary,
      body: Stack(
        children: [
          // Dot Pattern Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.2, // opacity-20
              child: CustomPaint(
                painter: DotPatternPainter(),
              ),
            ),
          ),
          
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Container
                      Container(
                        width: 192, // w-48 (48 * 4)
                        height: 192, // h-48
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.05), // bg-black/5
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: Center(
                          child: Container(
                            width: 80, // w-20
                            height: 80, // h-20
                            decoration: BoxDecoration(
                              color: TColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.handshake_outlined,
                              size: 48, // text-5xl (roughly 48px)
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32), // mb-8 (moved to here roughly)
                      
                      // Title
                      Text(
                        'TaskLink',
                        style: GoogleFonts.inter(
                          fontSize: 48, // text-5xl
                          fontWeight: FontWeight.w800, // font-extrabold
                          color: Colors.black,
                          letterSpacing: -0.025, // tracking-tight
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 16), // mb-4
                      
                      // Subtitle
                      Text(
                        'Your Local Help Marketplace.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18, // text-lg
                          fontWeight: FontWeight.w500, // font-medium
                          color: Colors.black.withValues(alpha: 0.8), // text-black/80
                          letterSpacing: 0.025, // tracking-wide
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Loading Indicator Section
              Padding(
                padding: const EdgeInsets.only(bottom: 64), // pb-16
                child: Column(
                  children: [
                    const SizedBox(
                      width: 40, // w-10
                      height: 40, // h-10
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // border-black/80 equivalent
                        strokeWidth: 4,
                        backgroundColor: Colors.transparent, // border-black/10 handled by track? Flutter circular progress bg is complex to match exactly Tailwind border logic, but this is close.
                      ),
                    ),
                    const SizedBox(height: 8), // gap-2
                    Text(
                      'LOADING',
                      style: GoogleFonts.inter(
                        fontSize: 12, // text-xs
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withValues(alpha: 0.5), // text-black/50
                        letterSpacing: 2.4, // tracking-[0.2em] (0.2 * 12 = 2.4)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1) // slightly visible dots
      ..style = PaintingStyle.fill;

    const double spacing = 24.0;
    const double radius = 1.0;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        // Draw small dot
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
