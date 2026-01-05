import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_filter_bar.dart';
import 'home_task_card.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Filter Chips
        const HomeFilterBar(),
        
        // List Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '32 Tasks nearby',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
              ),
              Row(
                children: [
                  Text('Sort by: Distance', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[500])),
                  Icon(Icons.expand_more, size: 18, color: Colors.grey[500]),
                ],
              ),
            ],
          ),
        ),

        // Task Cards
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: const [
              HomeTaskCard(
                title: 'Help moving a sofa',
                price: 45,
                category: 'Moving • Small furniture',
                distance: '0.8 mi',
                time: '2h ago',
                color: Colors.amber, // Primary placeholder
                icon: Icons.widgets_outlined,
              ),
              HomeTaskCard(
                title: 'Deep Clean 1BR Apt',
                price: 120,
                category: 'Cleaning • Full apartment',
                distance: '3.2 mi',
                expires: 'Expires in 1h',
                color: Colors.blue,
                icon: Icons.cleaning_services_outlined,
              ),
              HomeTaskCard(
                 title: 'Lawn Mowing & Trimming',
                 price: 65,
                 category: 'Gardening • Medium yard',
                 distance: '1.5 mi',
                 time: '4h ago',
                 color: Colors.green,
                 icon: Icons.yard_outlined,
               ),
            ],
          ),
        ),
      ],
    );
  }
}
