import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/post_task_controller.dart';

class PostTaskLocationInput extends StatelessWidget {
  final PostTaskController controller;

  const PostTaskLocationInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF27272A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[500]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: controller.location,
                        decoration: InputDecoration(
                          hintText: 'Enter street address',
                          hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: GoogleFonts.inter(fontSize: 14, color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                   border: Border(top: BorderSide(color: Colors.transparent)),
                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                   image: DecorationImage(image: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuDjN1RmJ1dH0NKAakAA4KY1_T5CaBTrtDriYTkc_fyNAIoCnzrLxAvjmVU2T0NhWrNIP1k4Fy2TeRGU3JQx0z2plIf6suWtGthuMdF_HgXgA_Cq10IRW8jCD7nnADzAGy4uYRKmnKHjKRlgiTLa39-jO0L4UUg9kjfFadWWE3cYpAIihSPMBJBJ8eLp5fG7xgkyvmEUozLs--NqdjWR_YcmQwph682lKkRBxwAY0pXHLO9uF2bQi8te4mPJqslm2dgAclIF4UKczx2D'), fit: BoxFit.cover, opacity: 0.6),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: TColors.primary, border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle),
                        child: const Icon(Icons.location_on, size: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
