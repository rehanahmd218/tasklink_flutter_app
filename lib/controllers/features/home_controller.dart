import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tasklink/models/tasks/task_model.dart';
import 'package:tasklink/services/tasks/task_service.dart';

class HomeController extends GetxController {
  static final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final TaskService _taskService = TaskService();

  final isMapView = true.obs;

  // Tasks
  final RxList<TaskModel> nearbyTasks = <TaskModel>[].obs;
  final RxBool isLoading = false.obs;

  // Filter state
  final RxString currentCategory = 'All'.obs;
  final RxInt radius = 30.obs;

  // Filtered tasks getter
  List<TaskModel> get filteredTasks {
    if (currentCategory.value == 'All') {
      return nearbyTasks;
    }
    return nearbyTasks.where((task) {
      // Simple case-insensitive check
      return task.category.toUpperCase().contains(
            currentCategory.value.toUpperCase(),
          ) ||
          currentCategory.value.toUpperCase().contains(
            task.category.toUpperCase(),
          );
    }).toList();
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

      // Hardcoded location for now as per previous context or standard testing
      // In a real app, use Geolocation package to get actual position
      final double lat = 30.3753;
      final double lng = 69.3451;

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
      // Optional: Show error snackbar
    } finally {
      isLoading.value = false;
    }
  }
}
