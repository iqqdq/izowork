import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

class SingleObjectMapViewModel with ChangeNotifier {
  final MapObject object;

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

  bool get hasPermission => _hasPermission;

  LatLng? get userPosition => _userPosition;

  LatLng? get position => _position;

  SingleObjectMapViewModel(this.object) {
    places.add(Place(
        id: object.id,
        name: object.manager?.name ?? '-',
        color: object.objectStage?.color == null
            ? HexColors.primaryMain
            : HexColor(object.objectStage!.color!),
        latLng: LatLng(
          object.lat,
          object.long,
        )));

    _position = LatLng(
      object.lat,
      object.long,
    );

    getLocationPermission().whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void zoomIn(GoogleMapController googleMapController) {
    if (_position != null) {
      googleMapController.getZoomLevel().then((value) => googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: _position!,
            zoom: value + 1.0,
          ))));
    }
  }

  void zoomOut(GoogleMapController googleMapController) {
    if (_position != null) {
      googleMapController.getZoomLevel().then((value) => googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: _position!,
            zoom: value - 1.0,
          ))));
    }
  }

  void showUserLocation(GoogleMapController googleMapController) {
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _userPosition!,
      zoom: 20.0,
    )));
  }

  // MARK: -
  // MARK: - GEOCODING

  Future getUserLocation() async {
    if (hasPermission) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      _userPosition = LatLng(position.latitude, position.longitude);
    }
  }

  // MARK: -
  // MARK: - PERMISSION

  Future<void> getLocationPermission() async {
    await handlePermission().then((value) => {
          _hasPermission = value,
          notifyListeners(),
        });

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
