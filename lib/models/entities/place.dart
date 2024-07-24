import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with ClusterItem {
  final String id;
  final String name;
  final Color color;
  final LatLng latLng;

  Place({
    required this.id,
    required this.name,
    required this.color,
    required this.latLng,
  });

  @override
  LatLng get location => latLng;
}
