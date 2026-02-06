import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Test screen to preview all animations
class AnimationTestScreen extends StatelessWidget {
  const AnimationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.dark : TColors.light,
      appBar: AppBar(
        title: Text(
          'Animation Gallery',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Success & Completion Section
          _buildSectionHeader('Success & Completion', Icons.check_circle),
          _buildLottieCard('Check Register', TAnimations.greenTickAnimation),
          _buildLottieCard('Payment Successful', TAnimations.greenTickAnimation2),
          _buildLottieCard('Thank You', TAnimations.greenTickAnimation3),
          _buildLottieCard('Order Complete', TAnimations.orderCompleteDelivery),

          const SizedBox(height: 24),

          // Loading & Progress Section
          _buildSectionHeader('Loading & Progress', Icons.hourglass_empty),
          _buildLottieCard('Loader', TAnimations.loader),
          _buildLottieCard('Loading Juggle', TAnimations.loadingJuggle),
          _buildLottieCard('Packaging Progress', TAnimations.packagingInProgress),

          const SizedBox(height: 24),

          // Action Animations Section
          _buildSectionHeader('Actions', Icons.touch_app),
          _buildLottieCard('Cloud Uploading', TAnimations.cloudUploading),
          _buildLottieCard('Paper Plane', TAnimations.paperPlane),
          _buildLottieCard('Pencil Drawing', TAnimations.pencilDrawing),
          _buildLottieCard('Searching', TAnimations.searching),

          const SizedBox(height: 24),

          // Shopping & Transport Section
          _buildSectionHeader('Shopping & Transport', Icons.shopping_cart),
          
          _buildLottieCard('Car Rides', TAnimations.carRides),

          const SizedBox(height: 24),

          // Other Animations Section
          _buildSectionHeader('Other', Icons.category),
          _buildLottieCard('Empty File', TAnimations.emptyFile),
          _buildLottieCard('Doctor', TAnimations.docerAnimation),
          _buildLottieCard('Security Icon', TAnimations.securityIcon),


          
          

          
         
          const SizedBox(height: 24),

          // Generic Animations Section
          _buildSectionHeader('Generic Animations', Icons.animation),
          _buildLottieCard('Animation 1', TAnimations.otpAnimation),
          _buildLottieCard('Animation 2', TAnimations.securityLock),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: TColors.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLottieCard(String name, String animationPath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              animationPath,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: TColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: TColors.light.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Lottie.asset(
                  animationPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: TColors.error,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load animation',
                            style: GoogleFonts.inter(
                              color: TColors.error,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String name, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              imagePath,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: TColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: TColors.light.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: TColors.error,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: GoogleFonts.inter(
                              color: TColors.error,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
