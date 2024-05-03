import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/models/place_model.dart';

class ClusterHelper {
  ClusterManager initClusterManager({
    required Iterable<Place> places,
    required void Function(Set<Marker>) updateMarkers,
    required Future<Marker> Function(Cluster<Place>)? markerBuilder,
  }) =>
      ClusterManager<Place>(
        places,
        updateMarkers,
        markerBuilder: markerBuilder,
        stopClusteringZoom: 20.0,
        extraPercent: 0.2,
        levels: [
          1,
          4.25,
          6.75,
          8.25,
          11.5,
          14.5,
          16.0,
          16.5,
          20.0,
        ],
      );
}
