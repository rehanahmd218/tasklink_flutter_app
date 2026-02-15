import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasklink/common/widgets/loaders/full_screen_loader.dart';
import 'package:tasklink/common/widgets/snackbars/status_snackbar.dart';
import 'package:tasklink/models/tasks/task_create_request.dart';
import 'package:tasklink/services/tasks/task_service.dart';
import 'package:tasklink/utils/constants/animation_strings.dart';
import 'package:tasklink/utils/helpers/error_handler.dart';
import 'package:tasklink/models/location/location_search_result.dart';
import 'package:tasklink/services/location/geocoding_service.dart';
import 'package:tasklink/routes/routes.dart';

class PostTaskController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController(); // For Map location display
  final address = TextEditingController(); // For manual address text
  final budget = TextEditingController();
  final radius = TextEditingController(text: '1.0'); // Default 1.0 km

  final selectedCategory = ''.obs;
  final dueDate = Rx<DateTime?>(null);
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  // Location search
  final searchResults = <LocationSearchResult>[].obs;
  final isSearching = false.obs;
  final selectedLocationName = ''.obs;

  final images = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  // Services
  final TaskService _taskService = TaskService();
  final GeocodingService _geocodingService = GeocodingService();

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  /// Set location coordinates when user picks from map
  void setLocation(double lat, double lng, {String? locationName}) {
    latitude.value = lat;
    longitude.value = lng;
    if (locationName != null) {
      selectedLocationName.value = locationName;
      address.text = locationName;
    }
  }

  /// Search for locations based on query
  Future<void> searchLocation(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isSearching.value = true;
      final results = await _geocodingService.searchLocation(query);
      searchResults.value = results;
    } catch (e) {
      StatusSnackbar.showError(message: 'Failed to search location');
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  /// Select location from search results
  void selectLocationFromSearch(LocationSearchResult result) {
    latitude.value = result.latitude;
    longitude.value = result.longitude;
    selectedLocationName.value = result.displayName;
    address.text = result.displayName;
    searchResults.clear();
  }

  /// Handle map tap - reverse geocode to get address
  Future<void> handleMapTap(double lat, double lng) async {
    try {
      latitude.value = lat;
      longitude.value = lng;

      // Get address from coordinates
      final addressText = await _geocodingService.reverseGeocode(lat, lng);
      selectedLocationName.value = addressText;
      address.text = addressText;
    } catch (e) {
      StatusSnackbar.showError(message: 'Failed to get address');
    }
  }

  /// Clear search results
  void clearSearch() {
    searchResults.clear();
  }

  Future<void> pickImages() async {
    if (images.length >= 3) {
      Get.snackbar('Limit Reached', 'You can only add up to 3 images.');
      return;
    }

    try {
      // Don't use limit parameter as it causes issues
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        final remainingSlots = 3 - images.length;

        // Only take the number of images we can add
        final imagesToAdd = pickedFiles.take(remainingSlots).toList();

        images.addAll(imagesToAdd);

        // Show message if user selected more than we could add
        if (pickedFiles.length > remainingSlots) {
          Get.snackbar(
            'Limit Reached',
            'Only ${remainingSlots} image(s) added. Maximum is 3 images.',
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  /// Validate and submit task
  Future<void> submitTask() async {
    try {
      // Validate form fields
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Business logic validations (things not in form fields)
      if (selectedCategory.value.isEmpty) {
        StatusSnackbar.showError(message: 'Please select a category');
        return;
      }

      if (latitude.value == 0.0 || longitude.value == 0.0) {
        StatusSnackbar.showError(
          message: 'Please select a location on the map',
        );
        return;
      }

      FullScreenLoader.show(
        text: 'Creating task...',
        animation: TAnimations.cloudUploading,
      );

      // Create request object (form validation already ensured valid values)
      final request = TaskCreateRequest(
        title: title.text.trim(),
        description: description.text.trim(),
        category: selectedCategory.value.toUpperCase(),
        budget: double.parse(budget.text.trim()),
        latitude: 30.3753,
        longitude: 69.3451,
        addressText: address.text.trim(),
        radius: double.parse(radius.text.trim()),
        expiresAt: dueDate.value,
      );

      // Convert XFile to File
      final List<File> mediaFiles = [];
      for (var xfile in images) {
        mediaFiles.add(File(xfile.path));
      }

      // Call service
      await _taskService.createTask(request, mediaFiles);

      FullScreenLoader.hide();

      // Navigate to My Posted Tasks screen
      Get.offAllNamed(Routes.MY_POSTED_TASKS);

      // Show success message after navigation
      Future.delayed(const Duration(milliseconds: 300), () {
        StatusSnackbar.showSuccess(message: 'Task created successfully!');
      });
    } catch (e) {
      FullScreenLoader.hide();
      ErrorHandler.showErrorPopup(e, buttonText: 'Try Again');
    }
  }

  @override
  void onClose() {
    title.dispose();
    description.dispose();
    location.dispose();
    address.dispose();
    budget.dispose();
    radius.dispose();
    super.onClose();
  }
}
