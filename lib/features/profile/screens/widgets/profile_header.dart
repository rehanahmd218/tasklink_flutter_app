import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:tasklink/common/widgets/buttons/primary_button.dart';

class ProfileHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback onEditProfile;
  final VoidCallback onShare;

  const ProfileHeader({
    super.key,
    required this.isDark,
    required this.onEditProfile,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
           Stack(
             children: [
               Container(
                 width: 128, height: 128,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   border: Border.all(color: isDark ? const Color(0xFF2d2c1b) : Colors.white, width: 4),
                   image: const DecorationImage(image: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuDaA2akIlN7W67ScIeEypzQdV_kWwE39Mn5BsmZgolULqSXX_MexuXu_eYBYTlXJGveoHCoJt_ZmvibZoiqrJyb52NSA68tZCGWsk8Xs5OQ6v4XTsY2U4oyovg21fbP9f_ZTPuGi_4rdzRx8i70l_7o25J_IWFfTCGgvgmnpbdzgsCij9rYbCDdbdD_c9gHxM9LuKuggH1ATIILhqPO9-82jODnoARiE68GDHVqPZnOgSYwmpGGZXjbFX2GPOf9Pn-0D-351pwyNjXW'), fit: BoxFit.cover),
                   boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                 ),
               ),
               Positioned(
                 bottom: 4, right: 4,
                 child: Container(
                   padding: const EdgeInsets.all(6),
                   decoration: BoxDecoration(color: isDark ? const Color(0xFF2d2c1b) : Colors.white, shape: BoxShape.circle, border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[100]!)),
                   child: const Icon(Icons.verified, color: Colors.green, size: 20),
                 ),
               ),
             ],
           ),
           const SizedBox(height: 16),
           Text('Alex Johnson', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
           Text('Handyman & Assembly Expert', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
           const SizedBox(height: 4),
           Text('Member since Jan 2023', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400])),
           
           const SizedBox(height: 24),
           
           Row(
             children: [
               Expanded(
                 child: PrimaryButton(
                   onPressed: onEditProfile,
                   text: 'Edit Profile',
                   borderRadius: 12,
                 ),
               ),
               const SizedBox(width: 12),
               Container(
                 decoration: BoxDecoration(color: isDark ? const Color(0xFF2d2c1b) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!)),
                 child: IconButton(icon: Icon(Icons.share, color: isDark ? Colors.white : Colors.black), onPressed: onShare),
               ),
             ],
           ),
        ],
      ),
    );
  }
}
