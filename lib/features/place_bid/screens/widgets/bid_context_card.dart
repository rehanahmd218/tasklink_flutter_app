import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';

class BidContextCard extends StatelessWidget {
  const BidContextCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: TColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text('CLEANING', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.yellow[900])),
                ),
                const SizedBox(height: 8),
                Text('House Cleaning - 2 Bedroom', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundImage: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuBb19XInKwLHS_GwR-v5OfDu5qpGyJpKE9iiEARaB9HS4U119I-dxJbbAJvK4McwUttaRg5F69Wuf83TzhDTxOvjoYQeSn0BoAvjKyig3A1tzJg5hzEzigGhNGLL9nto5iufVsM6nAcba5Pb6UXKajL2X5nGCBf-2c-Yveg7d7a8QO5clIHTmelDNBCCw6P4l0Mgp2RczRoMZRLOkhPoQBzdHa_4ckLdb_qvRhmW27b74AQXQO126hpJSNFi4CLANDnN1tp8TWbACc2')),
                    const SizedBox(width: 8),
                    Text('Alice M.', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('•')),
                    Text('2h ago', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!),
            ),
            child: Column(
              children: [
                Text('Budget', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                Text('\$80', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
