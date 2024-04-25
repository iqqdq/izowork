import 'package:google_maps_flutter/google_maps_flutter.dart';

class BoundsHelper {
  LatLngBounds getBounds(List<LatLng> markers) {
    double minLat = markers.first.latitude;
    double maxLat = markers.first.latitude;
    double minLng = markers.first.longitude;
    double maxLng = markers.first.longitude;

    for (LatLng marker in markers) {
      if (marker.latitude < minLat) {
        minLat = marker.latitude;
      }
      if (marker.latitude > maxLat) {
        maxLat = marker.latitude;
      }
      if (marker.longitude < minLng) {
        minLng = marker.longitude;
      }
      if (marker.longitude > maxLng) {
        maxLng = marker.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
