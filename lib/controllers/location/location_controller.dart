import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:tasklink/common/widgets/dialogs/status_popup.dart';
import 'package:tasklink/services/location/location_service.dart';

// Assuming your StatusPopup is imported here
// import 'path_to_your_status_popup.dart';

class LocationController extends GetxController with WidgetsBindingObserver {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  bool _isPopupShowing = false;
  bool _isProcessing = false;

  final LocationService _locationService = LocationService();
  static LocationController instance = Get.find();

  @override
  void onInit() {
    super.onInit();
    // Add observer to detect when user comes back from Settings
    WidgetsBinding.instance.addObserver(this);
    // checkAndGetLocation();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When user returns to the app from Settings
    if (state == AppLifecycleState.resumed) {
      checkAndGetLocation();
    }
  }

  /// The main entry point to ensure location is ready
  Future<void> checkAndGetLocation() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      // 1. Check Service Status (GPS Toggle)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showEnableLocationPopup();
        _isProcessing = false;
        return;
      }

      // 2. Check Permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // User denied permission through system popup
          _showPermissionRequiredPopup();
          _isProcessing = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // User previously denied forever
        _showPermissionRequiredPopup();
        _isProcessing = false;
        return;
      }

      // 3. If we reach here, we have permission and service is enabled
      // Getting position with high accuracy often triggers the "Accuracy" popup
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          timeLimit: Duration(seconds: 10),
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      print("Location Secured: ${latitude.value}, ${longitude.value}");
    } catch (e) {
      print("Location Error: $e");
      // If a timeout or error occurs, re-check
      checkAndGetLocation();
    } finally {
      _isProcessing = false;
    }
  }

  void _showEnableLocationPopup() {
    if (_isPopupShowing) return;
    _isPopupShowing = true;

    StatusPopup.show(
      type: PopupType.warning,
      title: 'Location Required',
      message: 'Please enable location services to continue using the app.',
      buttonText: 'Enable Location',
      dismissible: false,
      onPressed: () async {
        Get.back();
        _isPopupShowing = false;
        await Geolocator.openLocationSettings();
        // The didChangeAppLifecycleState will re-trigger checkAndGetLocation
      },
    );
  }

  void _showPermissionRequiredPopup() {
    if (_isPopupShowing) return;
    _isPopupShowing = true;

    StatusPopup.show(
      type: PopupType.warning,
      title: 'Permission Required',
      message:
          'Location permission is mandatory for this app to function. Please allow it in settings.',
      buttonText: 'Open Settings',
      dismissible: false,
      onPressed: () async {
        Get.back();
        _isPopupShowing = false;
        await Geolocator.openAppSettings();
      },
    );
  }

  /// Send the current location to the backend
  Future<void> sendLocationToBackend() async {
    // Ensure we have a valid location first
    // await checkAndGetLocation();

    if (latitude.value != 0.0 && longitude.value != 0.0) {
      try {
        await _locationService.updateLocation(
          latitude: latitude.value,
          longitude: longitude.value,
        );
      } catch (e) {
        print("Failed to send location to backend: $e");
        // Optionally show a snackbar or silent fail
      }
    } else {
      print("Cannot send location: Coordinates are (0,0)");
    }
  }
}
