import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostTaskInfoTip extends StatelessWidget {
  const PostTaskInfoTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text('Taskers usually charge between \$20 - \$45 for similar tasks in your area.', style: GoogleFonts.inter(fontSize: 12, color: Colors.blue[800]))),
        ],
      ),
    );
  }
}
