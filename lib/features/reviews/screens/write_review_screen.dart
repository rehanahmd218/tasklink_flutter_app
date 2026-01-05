import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/features/reviews/screens/widgets/review_rating_section.dart';
import 'package:tasklink/features/reviews/screens/widgets/review_tasker_info.dart';
import 'package:tasklink/features/reviews/screens/widgets/review_text_input.dart';
import 'package:tasklink/features/reviews/screens/widgets/review_traits_selection.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  double _rating = 4.0;
  final TextEditingController _reviewController = TextEditingController();

  final List<String> _positiveTraits = ['Punctual', 'Friendly', 'Skilled', 'Efficient', 'Communicative', 'Tidy'];
  final List<String> _selectedTraits = ['Punctual', 'Friendly'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: PrimaryAppBar(
        title: 'Write Review',
        leading: IconButton(
          icon: Icon(Icons.close, color: isDark ? Colors.white : const Color(0xFF1c1c0d)),
          onPressed: () => Get.back(),
        ),
        showBackButton: false, // We use custom leading for close icon
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                const SizedBox(height: 32),
                
                // Profile & Headers
                ReviewTaskerInfo(
                  isDark: isDark,
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCC9XaGshkP3h_mtUb7Qmk6jh1llwQx8VfPm2Z4JhLeQD0AA5Gj7GjXFnCmvbXe0SSp-kv182NbtM0pWZdO5_Ui_gpCF4CcQm5f10oin1loD1JvbcVjoR0YVFaRNogwslOuz1dwVz85CYhvre8JSDi-6yCwKEewbRWGL9sIXqkUhgUIJ31YNsLk-TJWy6wZpkS6wc225xQDNLWtaoszWTvvpw-cZuXIQGqOtadY5wFX1AKz9Q9CUIeSJ-AmUNSH91gsN-spR86XCE9u',
                  taskerName: 'Sarah',
                  taskTitle: 'Fix leaking sink',
                ),
                
                const SizedBox(height: 32),
                
                // Star Rating
                ReviewRatingSection(
                  rating: _rating,
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Chips
                ReviewTraitsSelection(
                  isDark: isDark,
                  allTraits: _positiveTraits,
                  selectedTraits: _selectedTraits,
                  onTraitToggle: (trait) {
                    setState(() {
                      if (_selectedTraits.contains(trait)) {
                        _selectedTraits.remove(trait);
                      } else {
                        _selectedTraits.add(trait);
                      }
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Review Text
                ReviewTextInput(
                  isDark: isDark,
                  controller: _reviewController,
                ),
              ],
            ),
          ),
          
          // Sticky Submit Button
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
                border: Border(top: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[100]!)),
              ),
              child: PrimaryButton(
                onPressed: () {},
                text: 'Submit Review',
                icon: Icons.send,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
