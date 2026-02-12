class DistanceUtils {
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      double km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }
}
