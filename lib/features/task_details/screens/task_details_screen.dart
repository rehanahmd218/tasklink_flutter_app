import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/common/widgets/rounded_container.dart';
import 'package:tasklink/common/widgets/circular_icon.dart';
import 'package:tasklink/common/widgets/description_text.dart';
import 'package:tasklink/features/task_details/widgets/task_bid_card.dart';
import 'package:tasklink/features/task_details/widgets/task_detail_card.dart';
import 'package:tasklink/features/task_details/widgets/task_location_card.dart';
import 'package:tasklink/features/task_details/widgets/task_map_preview.dart';
import 'package:tasklink/features/task_details/widgets/task_poster_profile.dart';
import '../../../../utils/constants/colors.dart';
import 'package:tasklink/controllers/features/task_details_controller.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskRole role;

  const TaskDetailsScreen({super.key, this.role = TaskRole.tasker});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskDetailsController());
    controller.setRole(role); // Set initial role
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
      appBar: PrimaryAppBar(
        title: 'Task Details',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(role == TaskRole.poster ? Icons.edit : Icons.share, color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Space for footer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Banner (Poster Only)
                  if (role == TaskRole.poster)
                    RoundedContainer(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: TColors.primary,
                      showBorder: true,
                      borderColor: Colors.yellow[400]!.withValues(alpha: 0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.gavel, color: Colors.black, size: 20),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Bidding Open', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                  Text('Review your applicants below', style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
                                ],
                              ),
                            ],
                          ),
                          const CircularIcon(
                            icon: Icons.notifications_active,
                            backgroundColor: Colors.black12,
                            color: Colors.black,
                            size: 32,
                            iconSize: 18,
                          ),
                        ],
                      ),
                    ),
                  
                  // Header Info
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: role == TaskRole.poster ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         if (role == TaskRole.tasker)
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               RoundedContainer(
                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                 radius: 20,
                                 backgroundColor: TColors.primary,
                                 child: Text('\$50 - \$70', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                               ),
                               RoundedContainer(
                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                 radius: 8,
                                 backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                                 child: Row(
                                   children: [
                                     Icon(Icons.history, size: 16, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                                     const SizedBox(width: 4),
                                     Text('Posted 2h ago', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                                   ],
                                 ),
                               ),
                             ],
                           ),
                         const SizedBox(height: 12),
                         Text(
                           'Assemble IKEA Furniture',
                           style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: isDark ? Colors.white : TColors.textPrimary, letterSpacing: -0.5),
                         ),
                         if (role == TaskRole.poster)
                           Text(
                             '\$80 - \$100', // Poster viewed price
                             style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : TColors.textPrimary),
                           ),
                      ],
                    ),
                  ),
                  
                  // Poster Profile (Tasker Only)
                  if (role == TaskRole.tasker)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: TaskPosterProfile(
                        name: 'Sarah J.',
                        avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAeTNI267OH42tMNeuZ5RBsIHl7oFG3nNiCGwFtuvC8_w_aY7p_nBdoGbpGn8K2_YFj72G1t21HiBQlKRR2YAUMCKo5utOcSmqzvkIbnIF3t1BD8LF3y9l6948WUM83FM6E45Yz_qG9RLzxaGFK-97ChT7av0DGGQQgk7i31wO9NFeBXm4xqcQwIHsI8JRiU7aot_RebjdARNiZRNpZ9unEI1RvpwXl98LF3GLtQoMFye4xQLWqJxUMdXuIvDeknJfKOiXtLf8DTUil',
                        rating: 4.9,
                        reviews: 120,
                      ),
                    ),

                  // Meta Grid (Date, Category, Location)
                  if (role == TaskRole.tasker)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                           Expanded(child: TaskDetailCard(
                             icon: Icons.calendar_today, 
                             label: 'Date & Time', 
                             value: 'Today, 2:00 PM', 
                             color: Colors.blue
                           )),
                           SizedBox(width: 12),
                           Expanded(child: TaskDetailCard(
                             icon: Icons.category, 
                             label: 'Category', 
                             value: 'Assembly', 
                             color: Colors.orange
                           )),
                        ],
                      ),
                    ),
                    
                  // Location
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TaskLocationCard(location: 'SoHo, New York • 3.2 miles away'),
                    ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description, color: TColors.primary),
                            const SizedBox(width: 8),
                            Text('Description', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                          ],
                        ),
                         const SizedBox(height: 12),
                         RoundedContainer(
                           padding: const EdgeInsets.all(16),
                           backgroundColor: isDark ? const Color(0xFF27272A) : Colors.grey[50],
                           child: const DescriptionText(
                             text: "I have a large Pax wardrobe from IKEA that needs assembly. It's the 236cm height version with sliding doors.\n\nAll parts are in the boxes in the bedroom where it needs to be built. There is enough space to work.\n\nPlease bring your own tools (screwdriver, drill, etc.). I will be home to buzz you in.",
                             expandable: true,
                           ),
                         ),
                      ],
                    ),
                  ),
                  
                  // Map Preview
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     child: TaskMapPreview(mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDCmHJUj7e2sEOM5Df_dG57kg6DOo1rHlrz8kYw_Knads_lcF59fa09Ze7JpDmbs1CzrovkoiROs0TKsD2WBTEt43jm_qN0D9_Itwb69LvKrrcHkk1k2XVg5Y8VWfg7Mk0-mGoENnALkDiYqRvgNxIjqbywzeP8tk40NICkOloNOQr-3hG04QA49bR3pCwpmxYvRRJZse0FaoeC2BmjYun2bliRI9HQBhJGm5t9QZUWFLqA8lxSQIFBwr_tpe5Nt-lFwM8WORidOCnS'),
                  ),

                  // Bids List (Poster Only)
                  if (role == TaskRole.poster)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Received Bids (3)', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                              Row(children: [Text('Sort by', style: GoogleFonts.inter(color: Colors.grey[600])), const Icon(Icons.keyboard_arrow_down, size: 16)]),
                            ],
                          ),
                          const SizedBox(height: 16),
                           const TaskBidCard(
                             name: 'John D.',
                             price: 90,
                             imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAxCA7dJLW0xPBVxzHPf1r_nhPzY51o2ziCaOv-Ygt6mIn3cZw9XMqrLMr5LkKCumvC4_xV2cJZhC5PyxlJXH9X4vHSOSrATbrndg8oU6KGVU-qjVDU_K1O5P214hpEYv0pC1lMYf_L0cBUVlDs-HczYxoWmBiarrMvhoOHi--irqLJwBRZSX9hAj84V5YwEiqSUEYLRv9AlvAYXDWGQKWXOoxOLXaRPrRSwuit0kp7TL7kVAkBruB5uFcp-TlRBj3lrwKA-nvUe9sY',
                             message: '"I have built 50+ of these PAX wardrobes. I have my own tools and can come by today around 4pm."',
                           ),
                           const TaskBidCard(
                             name: 'Sarah L.',
                             price: 85,
                             imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDZ5UVh8k_YoYW9uUxzwtpNLBN4TyEDiFYFEPQwoGzsh2J7tn__oqnLetVkESDS-55ZMEcXky0NdmQc2u6Q0nulhXZGW1t4bzlivj-U-JPmk0yCi7GClU-WtJ2Vm1W2J_RDCkJGutLiXek_1F7ZkXqzqr2bZZiqpGl1qXBwDNOr1Ueja3js5ya3Dy3sKs3f56EYbAtMsza0EYINS2kgoJVi-dI7ZsBL2CCXmZnvDv4tWt2375SeNkUjARKmqCoIM5e_qcZNShxGf5pB',
                             message: '"Available tomorrow morning. I am very detailed and tidy."',
                           ),
                        ],
                      ),
                    ),
                    
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Sticky Footer (Tasker Only)
          if (role == TaskRole.tasker)
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: isDark ? TColors.backgroundDark : Colors.white,
                 border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
                 boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        Text('Estimated Payout', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500])),
                        Text('\$50 - \$70', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: isDark ? Colors.white : Colors.black)),
                     ],
                   ),
                   const SizedBox(height: 12),
                   PrimaryButton(
                      onPressed: () {},
                      text: 'Place a Bid',
                      icon: Icons.gavel,
                    ),
                 ],
               ),
             ),
        ],
      ),
    );
  }


}
