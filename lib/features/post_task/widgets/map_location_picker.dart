import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:tasklink/controllers/features/post_task_controller.dart';
import 'package:tasklink/controllers/location/location_controller.dart';
import 'package:tasklink/utils/constants/colors.dart';

class MapLocationPicker extends StatefulWidget {
  final PostTaskController controller;

  const MapLocationPicker({super.key, required this.controller});

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  late LatLng _selectedLocation;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current location or default
    final locationController = Get.find<LocationController>();
    if (widget.controller.latitude.value != 0.0 &&
        widget.controller.longitude.value != 0.0) {
      _selectedLocation = LatLng(
        widget.controller.latitude.value,
        widget.controller.longitude.value,
      );
    } else if (locationController.latitude.value != 0.0) {
      _selectedLocation = LatLng(
        locationController.latitude.value,
        locationController.longitude.value,
      );
    } else {
      // Default to Lahore, Pakistan
      _selectedLocation = LatLng(31.5204, 74.3587);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _isLoadingAddress = true;
    });

    // Reverse geocode to get address
    await widget.controller.handleMapTap(position.latitude, position.longitude);

    setState(() {
      _isLoadingAddress = false;
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      widget.controller.clearSearch();
      return;
    }

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        widget.controller.searchLocation(query);
      }
    });
  }

  void _confirmLocation() {
    widget.controller.setLocation(
      _selectedLocation.latitude,
      _selectedLocation.longitude,
      locationName: widget.controller.address.text,
    );
    Get.back();
  }

  void _goToCurrentLocation() {
    final locationController = Get.find<LocationController>();
    if (locationController.latitude.value != 0.0) {
      setState(() {
        _selectedLocation = LatLng(
          locationController.latitude.value,
          locationController.longitude.value,
        );
      });
      _mapController.move(_selectedLocation, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? TColors.backgroundDark : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? TColors.backgroundDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Select Location',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF27272A) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for a location...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon: Obx(() {
                        if (widget.controller.isSearching.value) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        if (_searchController.text.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              widget.controller.clearSearch();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                // Search Results
                Obx(() {
                  if (widget.controller.searchResults.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF27272A) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.controller.searchResults.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                      ),
                      itemBuilder: (context, index) {
                        final result = widget.controller.searchResults[index];
                        return ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: TColors.primary,
                          ),
                          title: Text(
                            result.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            widget.controller.selectLocationFromSearch(result);
                            setState(() {
                              _selectedLocation = LatLng(
                                result.latitude,
                                result.longitude,
                              );
                            });
                            _mapController.move(_selectedLocation, 15.0);
                            _searchController.clear();
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 13.0,
                    onTap: _onMapTap,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tasklink.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: TColors.primary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Zoom Controls
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(
                            _selectedLocation,
                            currentZoom + 1,
                          );
                        },
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(
                            _selectedLocation,
                            currentZoom - 1,
                          );
                        },
                        child: const Icon(Icons.remove, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                // Current Location Button
                Positioned(
                  right: 16,
                  bottom: 200,
                  child: FloatingActionButton.small(
                    heroTag: 'current_location',
                    backgroundColor: Colors.white,
                    onPressed: _goToCurrentLocation,
                    child: const Icon(Icons.my_location, color: Colors.black),
                  ),
                ),

                // Loading Indicator
                if (_isLoadingAddress)
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Getting address...',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Confirm Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? TColors.backgroundDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.controller.address.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.controller.address.text,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirm Location',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
