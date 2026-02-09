import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/controllers/user_controller.dart';
import 'package:tasklink/services/user/user_service.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';

class EditProfileController extends GetxController {
  static EditProfileController get instance => Get.find();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  // Observable values
  final selectedGender = Rxn<String>();
  final selectedDate = Rxn<DateTime>();
  final profileImage = Rxn<File>();
  final isLoading = false.obs;

  // Services
  final UserService _userService = UserService();
  final UserController userController = UserController.instance;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  /// Load current user data into form fields
  void _loadUserData() {
    final user = userController.currentUser.value;
    if (user == null) return;

    fullNameController.text = user.profile?.fullName ?? '';
    bioController.text = user.profile?.bio ?? '';
    phoneController.text = user.phoneNumber;
    emailController.text = user.email;

    if (user.profile?.dateOfBirth != null) {
      selectedDate.value = user.profile!.dateOfBirth;
      dateOfBirthController.text = _formatDate(user.profile!.dateOfBirth!);
    }

    if (user.profile?.gender != null) {
      selectedGender.value = _genderCodeToDisplay(user.profile!.gender);
    }
  }

  /// Convert gender code to display value
  String? _genderCodeToDisplay(String? code) {
    if (code == null) return null;
    switch (code.toUpperCase()) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'O':
        return 'Non-binary';
      case 'N':
        return 'Prefer not to say';
      default:
        return code; // Already a display value
    }
  }

  /// Convert gender display value to code
  String? _genderDisplayToCode(String? display) {
    if (display == null) return null;
    switch (display) {
      case 'Male':
        return 'M';
      case 'Female':
        return 'F';
      case 'Non-binary':
        return 'O';
      case 'Prefer not to say':
        return 'N';
      default:
        return display; // Already a code
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        StatusSnackbar.showSuccess(message: 'Image selected successfully');
      }
    } catch (e) {
      StatusSnackbar.showError(message: 'Failed to pick image: $e');
    }
  }

  /// Show date picker
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFf9f506),
              onPrimary: Colors.black,
              surface: isDark ? const Color(0xFF2d2c1b) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateOfBirthController.text = _formatDate(picked);
    }
  }

  /// Update profile
  Future<void> updateProfile() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      FullScreenLoader.show(
        text: 'Updating profile...',
        animation: TAnimations.pencilDrawing,
      );
      isLoading.value = true;

      final updatedUser = await _userService.updateProfile(
        fullName: fullNameController.text.trim().isNotEmpty
            ? fullNameController.text.trim()
            : null,
        bio: bioController.text.trim().isNotEmpty
            ? bioController.text.trim()
            : null,
        dateOfBirth: selectedDate.value,
        gender: _genderDisplayToCode(selectedGender.value),
        profileImage: profileImage.value,
      );

      // Update user in controller
      userController.setUser(updatedUser);

      FullScreenLoader.hide();
      isLoading.value = false;

      // Show success message
      Get.back();
      await Future.delayed(const Duration(milliseconds: 300));
      StatusSnackbar.showSuccess(message: 'Profile updated successfully!');

      // Wait a moment for user to see the success message, then go back
    } catch (e) {
      FullScreenLoader.hide();
      isLoading.value = false;

      // Use global error handler
      ErrorHandler.showErrorPopup(e, buttonText: 'Try Again');
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}
