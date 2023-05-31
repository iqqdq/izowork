import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/place_model.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/screens/map_object/map_object_screen_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SingleObjectMapViewModel with ChangeNotifier {
  final Object object;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  // CLUSTER
  Set<Marker> markers = {};
  List<Place> places = [];

  // LOCAL
  LatLng? _position;
  LatLng? _userPosition;

  // PERMISSION
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  bool _hasPermission = false;

  bool isHidden = true;

  bool get hasPermission {
    return _hasPermission;
  }

  LatLng? get userPosition {
    return _userPosition;
  }

  LatLng? get position {
    return _position;
  }

  SingleObjectMapViewModel(this.object) {
    places.add(Place(
        id: object.id,
        name: object.manager?.name ?? '-',
        latLng: LatLng(object.lat, object.long)));

    getLocationPermission().then((value) => notifyListeners());
  }

  // MARK: -
  // MARK: - ACTIONS

  void zoomIn(GoogleMapController googleMapController) {
    if (_position != null) {
      googleMapController.getZoomLevel().then((value) =>
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _position!, zoom: value + 1.0))));
    }
  }

  void zoomOut(GoogleMapController googleMapController) {
    if (_position != null) {
      googleMapController.getZoomLevel().then((value) =>
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _position!, zoom: value - 1.0))));
    }
  }

  void showUserLocation(GoogleMapController googleMapController) {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _userPosition!, zoom: 16.0)));
  }

  // MARK: -
  // MARK: - PUSH

  void showMapObjectSheet(BuildContext context, String id) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            MapObjectScreenWidget(object: object, hideInfoButton: true));
  }

  // MARK: -
  // MARK: - GEOCODING

  Future getUserLocation() async {
    if (hasPermission) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      _userPosition = LatLng(position.latitude, position.longitude);
      _position ??= _userPosition;
    }
  }

  // MARK: -
  // MARK: - PERMISSION

  Future<void> getLocationPermission() async {
    await handlePermission()
        .then((value) => {_hasPermission = value, notifyListeners()});

    if (_hasPermission) {
      getUserLocation();
    }
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _hasPermission = false;
    }

    permission = await _geolocatorPlatform.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();

      if (permission == LocationPermission.denied) {
        _hasPermission = false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _hasPermission = false;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _hasPermission = true;
    }

    return _hasPermission;
  }

  // MARK: -
  // MARK: - LOCATIONS

  void updateMarkers(Set<Marker> markers) {
    debugPrint('Updated ${markers.length} markers');
    this.markers = markers;
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void onCameraMove(CameraPosition position) {
    _position = position.target;
  }
}
