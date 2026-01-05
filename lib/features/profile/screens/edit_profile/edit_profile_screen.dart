import 'package:flutter/material.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/primary_button.dart';
import 'package:tasklink/features/profile/screens/widgets/profile_picture_uploader.dart';
import 'package:tasklink/common/widgets/app_dropdown.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
      appBar: const PrimaryAppBar(title: 'Edit Profile'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            child: Column(
              children: [
                // Profile Picture
                ProfilePictureUploader(
                  isDark: isDark,
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC8zGzp9htord6EnIFWnnH3xsWKc1W6dnKb0fbuCPDSnI-kVjlzVxWIOhPSDmArs0Py9ZaVhD80JfGfpWkrPzFIK4URrKwYBwYKbxSuj-B0yDehQer1w-jXOUvxroxBiwI79JWRD1DlfVdLUY3leBIxbATIS4zdBRMNOSKHkm8NP43PXD6bSYwfVePdBpRhtNw4FKVCbqhQysV_M3uZxZMkfQshuursuvedTsWdiBM9t8_fJjEmoF5TKQF_tDXWtWS61WrhkYSGUnIa',
                  onTap: () {},
                ),
                const SizedBox(height: 32),
                
                // Form Fields
                AppTextField(
                  label: 'Full Name',
                  controller: TextEditingController(text: 'John Doe'),
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Bio',
                  controller: TextEditingController(text: 'Experienced handyman with over 5 years of helping neighbors with plumbing, furniture assembly, and minor repairs. Friendly and reliable!'),
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email',
                  controller: TextEditingController(text: 'john.doe@example.com'),
                  prefixIcon: Icons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Date of Birth',
                        controller: TextEditingController(text: '1990-05-15'),
                        prefixIcon: Icons.calendar_today,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: AppDropdown(
                        label: 'Gender',
                        value: 'Male',
                        items: const ['Male', 'Female', 'Non-binary', 'Prefer not to say'],
                        onChanged: (val) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Sticky Bottom Button
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                     isDark ? const Color(0xFF23220f).withValues(alpha: 0) : const Color(0xFFf8f8f5).withValues(alpha: 0),
                     isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
                  ],
                ),
              ),
              child: PrimaryButton(
                onPressed: () {},
                text: 'Save Changes',
              ),
            ),
          ),
        ],
      ),
    );
  }

}
