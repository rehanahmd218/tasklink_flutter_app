class LocationSearchResult {
  final String displayName;
  final double latitude;
  final double longitude;
  final String? addressType;
  final String? placeId;

  LocationSearchResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.addressType,
    this.placeId,
  });

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) {
    return LocationSearchResult(
      displayName: json['display_name'] ?? '',
      latitude: double.parse(json['lat'] ?? '0.0'),
      longitude: double.parse(json['lon'] ?? '0.0'),
      addressType: json['type'],
      placeId: json['place_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'display_name': displayName,
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'type': addressType,
      'place_id': placeId,
    };
  }
}
