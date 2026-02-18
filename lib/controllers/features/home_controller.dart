import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/controllers/location/location_controller.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/services/location/geocoding_service.dart';
import 'package:tasklink/services/tasks/task_service.dart';

class HomeController extends GetxController {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final TaskService _taskService = TaskService();
  final GeocodingService _geocodingService = GeocodingService();

  final isMapView = true.obs;

  /// Current location as "City, Country" from reverse geocoding (plain text for header).
  final RxString locationLabel = ''.obs;

  // Tasks
  final RxList<TaskModel> nearbyTasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;

  // Filter state: empty string = "All", otherwise backend category id (e.g. CLEANING, DELIVERY).
  final RxString currentCategory = ''.obs;
  final RxInt radius = 30.obs;

  // Filtered tasks getter
  List<TaskModel> get filteredTasks {
    if (currentCategory.value.isEmpty) {
      return nearbyTasks;
    }
    return nearbyTasks.where((task) =>
        task.category.toUpperCase() == currentCategory.value.toUpperCase()).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchNearbyTasks();
  }

  void toggleViewMode(bool isMap) {
    isMapView.value = isMap;
  }

  void updateRadius(int newRadius) {
    radius.value = newRadius;
    fetchNearbyTasks(); // Re-fetch when radius changes
  }

  void setCategoryFilter(String category) {
    currentCategory.value = category;
  }

  Future<void> fetchNearbyTasks() async {
    try {
      isLoading.value = true;

      final locationController = LocationController.instance;
      final double lat = locationController.latitude.value;
      final double lng = locationController.longitude.value;

      if (lat != 0.0 || lng != 0.0) {
        _updateLocationLabel(lat, lng);
      }

      final tasks = await _taskService.getNearbyTasks(
        lat: lat,
        lng: lng,
        radius: radius.value,
      );

      nearbyTasks.value = tasks;
      _log.i('Fetched ${nearbyTasks.length} nearby tasks');
    } catch (e) {
      _log.e('Error fetching nearby tasks: $e');
      nearbyTasks.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Builds "City, Country" from reverse geocoding and updates [locationLabel].
  Future<void> _updateLocationLabel(double latitude, double longitude) async {
    try {
      final address = await _geocodingService.getAddressDetails(
        latitude,
        longitude,
      );
      if (address == null) return;

      final country = address['country']?.toString().trim() ?? '';
      final city = address['city']?.toString().trim() ??
          address['town']?.toString().trim() ??
          address['village']?.toString().trim() ??
          address['municipality']?.toString().trim() ??
          '';

      final parts = [city, country].where((s) => s.isNotEmpty);
      locationLabel.value = parts.join(', ');
    } catch (e) {
      _log.e('Error updating location label: $e');
    }
  }
}
