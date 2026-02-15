import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:tasklink/utils/constants/colors.dart';

/// Read-only Map Viewer for Task Location
///
/// Shows the task location on a map without editing capabilities
class TaskLocationMapViewer extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  final double radius;

  const TaskLocationMapViewer({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.radius,
  });

  @override
  State<TaskLocationMapViewer> createState() => _TaskLocationMapViewerState();
}

class _TaskLocationMapViewerState extends State<TaskLocationMapViewer> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final location = LatLng(widget.latitude, widget.longitude);

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
          'Task Location',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Address Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF27272A) : Colors.grey[100],
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: TColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.address,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.latitude.toStringAsFixed(4)}, ${widget.longitude.toStringAsFixed(4)} • ${widget.radius.toStringAsFixed(1)} km radius',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
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
                    initialCenter: location,
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tasklink.app',
                    ),
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: location,
                          radius: widget.radius * 1000, // Convert km to meters
                          useRadiusInMeter: true,
                          color: TColors.primary.withValues(alpha: 0.1),
                          borderColor: TColors.primary,
                          borderStrokeWidth: 2,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: location,
                          width: 40,
                          height: 40,
                          child: const Icon(
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
                          _mapController.move(location, currentZoom + 1);
                        },
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          final currentZoom = _mapController.camera.zoom;
                          _mapController.move(location, currentZoom - 1);
                        },
                        child: const Icon(Icons.remove, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                // Center on Location Button
                Positioned(
                  right: 16,
                  bottom: 200,
                  child: FloatingActionButton.small(
                    heroTag: 'center_location',
                    backgroundColor: Colors.white,
                    onPressed: () {
                      _mapController.move(location, 15.0);
                    },
                    child: const Icon(Icons.my_location, color: Colors.black),
                  ),
                ),

                // Info Badge
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Task visible within ${widget.radius.toStringAsFixed(1)} km radius',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
