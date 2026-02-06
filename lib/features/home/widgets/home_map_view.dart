import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';

class HomeMapView extends StatelessWidget {
  const HomeMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Map Background
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCLJTzdFRx87p900Sdt6kfjxF0WTlsI6tfTPbepnG2XvoYZC03wkWlzN4iIBymNhDDJM7SfKowyxVzxVN7B-VB8P0vkI43pJwoOLIgerx_8Y89xudayjPyScXuvWEHp02Dae9VPVQXlFtwaAV24JGjfL2eaiceprPpFdUtg8MdYElObLgTga1uxwPjaTtqbXuaFwVsjwKglxAE0-ij5vtdeO-QMaHiuo6s9-_3qa5pcAZ5NtxFi89C3e5Z3oh_dfsrAhXP3tGLffUn3',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[300]),
            errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.error))),
          ),
        ),
        
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        // Filter FAB
        Positioned(
          top: 16, // Relative to map area, container has padding? 
          // Header is above this widget in HomeScreen Column. 
          right: 16,
          child: Container(
             height: 48,
             width: 48,
             decoration: BoxDecoration(
               color: isDark ? const Color(0xFF1F2937) : Colors.white,
               shape: BoxShape.circle,
               boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
               border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[100]!),
             ),
             child: Icon(Icons.tune, color: isDark ? Colors.white : Colors.grey[800]),
          ),
        ),
        
        // Map Pins (Hardcoded positions based on HTML)
        _buildPin(top: 0.3, left: 0.25, price: 45),
        _buildPin(top: 0.2, right: 0.3, price: 90),
        _buildPin(bottom: 0.4, right: 0.15, price: 55),
        
        // Active Pin
        Positioned(
          top: MediaQuery.of(context).size.height * 0.48 - 150, // approx adjustment
          left: MediaQuery.of(context).size.width * 0.55 - 20,
          child: Column(
            children: [
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                 decoration: BoxDecoration(
                   color: TColors.primary,
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Colors.white, width: 2),
                   boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8)],
                 ),
                 child: Text(
                   '\$65',
                   style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                 ),
               ),
               // Triangle
               CustomPaint(
                 size: const Size(16, 10),
                 painter: TrianglePainter(color: TColors.primary),
               ),
            ],
          ),
        ),
        
        // Task Preview Bottom Sheet
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white, // gray-900 or white
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 4))],
              border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[100]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('ASSEMBLY', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[300] : Colors.grey[600])),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            Text('4.9', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[500])),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('IKEA Pax Wardrobe Setup', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      ],
                    ),
                    Text('\$65', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Info Row
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text('0.8 mi away', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[500])),
                    const SizedBox(width: 16),
                    Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text('Posted 2h ago', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[500])),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () {},
                        text: 'View Details',
                        icon: Icons.arrow_forward,
                        borderRadius: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.bookmark_outline, color: isDark ? Colors.grey[300] : Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPin({double? top, double? left, double? right, double? bottom, required int price}) {
    // Simplified positioning for demo. In real map this uses LatLng.
    // Using Positioned with MediaQuery logic simplified.
    return Positioned( // This won't work perfectly inside a Stack unless we know the size. 
      // But HomeMapView expands? Yes.
      top: top != null ? 800 * top : null, // 800 is approx height
      left: left != null ? 400 * left : null,
      right: right != null ? 400 * right : null,
      bottom: bottom != null ? 800 * bottom : null,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4)],
            ),
            child: Text(
              '\$$price',
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
           CustomPaint(
             size: const Size(12, 8),
             painter: TrianglePainter(color: Colors.grey[900]!),
           ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
