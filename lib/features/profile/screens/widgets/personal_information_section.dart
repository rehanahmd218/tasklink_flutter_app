import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasklink/controllers/user_controller.dart';

class PersonalInformationSection extends StatelessWidget {
  final bool isDark;

  const PersonalInformationSection({super.key, required this.isDark});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  String _formatGender(String? gender) {
    if (gender == null) return 'N/A';
    switch (gender.toUpperCase()) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'O':
        return 'Other';
      case 'N':
        return 'Prefer not to say';
      default:
        return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;

    return Obx(() {
      final user = userController.currentUser.value;
      final profile = user?.profile;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'Personal Information',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Information Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2d2c1b) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email
                  _buildInfoField(label: 'EMAIL', value: user?.email ?? 'N/A'),
                  _buildDivider(),

                  // Phone Number
                  _buildInfoField(
                    label: 'PHONE NUMBER',
                    value: user?.phoneNumber ?? 'N/A',
                  ),
                  _buildDivider(),

                  // Bio
                  _buildInfoField(
                    label: 'BIO',
                    value: profile?.bio ?? 'N/A',
                    isMultiline: true,
                  ),
                  _buildDivider(),

                  // Date of Birth and Gender (Grid)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoField(
                          label: 'DATE OF BIRTH',
                          value: _formatDate(profile?.dateOfBirth),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoField(
                          label: 'GENDER',
                          value: _formatGender(profile?.gender),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isMultiline ? FontWeight.normal : FontWeight.w500,
            color: isDark
                ? (isMultiline ? Colors.grey[300] : Colors.grey[100])
                : (isMultiline ? Colors.grey[600] : Colors.grey[900]),
            height: isMultiline ? 1.5 : 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: isDark ? Colors.grey[800] : Colors.grey[50],
    );
  }
}
