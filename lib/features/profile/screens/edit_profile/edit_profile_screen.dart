import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasklink/common/widgets/primary_app_bar.dart';
import 'package:tasklink/common/widgets/buttons/primary_button.dart';
import 'package:tasklink/features/profile/screens/widgets/profile_picture_uploader.dart';
import 'package:tasklink/common/widgets/app_dropdown.dart';
import 'package:tasklink/common/widgets/app_text_field.dart';
import 'package:tasklink/controllers/profile/edit_profile_controller.dart';
import 'package:tasklink/utils/validators/form_validators.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF23220f)
          : const Color(0xFFf8f8f5),
      appBar: const PrimaryAppBar(title: 'Edit Profile'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  // Profile Picture
                  Obx(() {
                    final user = controller.userController.currentUser.value;
                    final imageUrl = user?.profile?.profileImage;
                    final localImage = controller.profileImage.value;

                    return ProfilePictureUploader(
                      isDark: isDark,
                      imageUrl: imageUrl,
                      localImage: localImage,
                      onTap: controller.pickImageFromGallery,
                    );
                  }),
                  const SizedBox(height: 32),

                  // Full Name
                  AppTextField(
                    label: 'Full Name',
                    controller: controller.fullNameController,
                    prefixIcon: Icons.person,
                    validator: FormValidators.validateFullName,
                  ),
                  const SizedBox(height: 20),

                  // Bio
                  AppTextField(
                    label: 'Bio',
                    controller: controller.bioController,
                    maxLines: 4,
                    validator: (value) {
                      if (value != null && value.length > 500) {
                        return 'Bio must be less than 500 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email (Read-only)
                  AppTextField(
                    label: 'Email',
                    controller: controller.emailController,
                    prefixIcon: Icons.mail,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),

                  // Phone Number (Read-only)
                  AppTextField(
                    label: 'Phone Number',
                    controller: controller.phoneController,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),

                  // Date of Birth and Gender
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectDateOfBirth(context),
                          child: AbsorbPointer(
                            child: AppTextField(
                              label: 'Date of Birth',
                              controller: controller.dateOfBirthController,
                              prefixIcon: Icons.calendar_today,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Obx(
                          () => AppDropdown(
                            label: 'Gender',
                            value: controller.selectedGender.value,
                            items: const [
                              'Male',
                              'Female',
                              'Non-binary',
                              'Prefer not to say',
                            ],
                            hint: 'Select gender',
                            onChanged: (val) {
                              controller.selectedGender.value = val;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isDark
                        ? const Color(0xFF23220f).withValues(alpha: 0)
                        : const Color(0xFFf8f8f5).withValues(alpha: 0),
                    isDark ? const Color(0xFF23220f) : const Color(0xFFf8f8f5),
                  ],
                ),
              ),
              child: Obx(
                () => PrimaryButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.updateProfile,
                  text: 'Save Changes',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
