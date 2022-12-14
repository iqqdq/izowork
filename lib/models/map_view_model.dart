import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:izowork/api/keys.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';

class MapViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // LOCAL
  LatLng _location = const LatLng(55.75461866442987, 37.620771608488646);
  LatLng? _userLocation;

  // PERMISSION
  bool _hasPermission = false;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  // GEOCODER
  final List<AutocompletePrediction> _predictions = [];
  String _city = '';
  String _address = '';

  // DATA
  String _error = '';

  bool get hasPermission {
    return _hasPermission;
  }

  LatLng? get userLocation {
    return _userLocation;
  }

  LatLng get location {
    return _location;
  }

  List<AutocompletePrediction> get predictions {
    return _predictions;
  }

  String get city {
    return _city;
  }

  String get address {
    return _address;
  }

  String get error {
    return _error;
  }

  MapViewModel() {
    getCurrentPosition();
  }

  // MARK: -
  // MARK: - ACTIONS

  void zoomIn(GoogleMapController googleMapController) {
    googleMapController.getZoomLevel().then((value) =>
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _location, zoom: value + 1.0))));
  }

  void zoomOut(GoogleMapController googleMapController) {
    googleMapController.getZoomLevel().then((value) =>
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _location, zoom: value - 1.0))));
  }

  void showUserLocation(GoogleMapController googleMapController) {
    if (hasPermission && userLocation != null) {
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: userLocation!, zoom: 16.0)));
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void onCameraMove() {
    Future.delayed(const Duration(seconds: 1), () => getAddressName());
  }

  void updateLocation(LatLng location) {
    _address = '';
    _location = location;
    notifyListeners();
  }

  Future reset() async {
    loadingStatus = LoadingStatus.empty;
    _error = '';
    notifyListeners();
  }

  // MARK: -
  // MARK: - GEOCODING

  Future getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    _userLocation = LatLng(position.latitude, position.longitude);
    _location = LatLng(position.latitude, position.longitude);
  }

  void getAddressName() async {
    GoogleGeocodingApi api = GoogleGeocodingApi(google_geocoding_api_key,
        isLogged: false); // TODO - isLogged: false
    GoogleGeocodingResponse reversedSearchResults = await api.reverse(
        '${_location.latitude}, ${_location.longitude}',
        language: locale);

    // GET CITY
    for (var element in reversedSearchResults.results.first.addressComponents) {
      if (element.types.contains('locality')) {
        _city = element.longName;
      }

      // GET FORMATTED ADDRESS
      _address = reversedSearchResults.results.first.formattedAddress;
    }

    notifyListeners();
  }

  void getAddressDetils(GoogleMapController controller, String placeId) async {
    DetailsResponse? result =
        await GooglePlace(google_geocoding_api_key).details.get(placeId);
    if (result != null &&
        result.result != null &&
        result.result?.geometry != null) {
      if (result.result?.geometry?.location != null) {
        _location = LatLng(result.result!.geometry!.location!.lat!,
            result.result!.geometry!.location!.lng!);

        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _location, zoom: 18)));
      }
    }
  }

  // MARK: -
  // MARK: - PERMISSION

  Future<void> getCurrentPosition() async {
    _hasPermission = await handlePermission();

    if (!_hasPermission) {
      return;
    } else {
      notifyListeners();
    }
  }

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      updatePositionList(_kLocationServicesDisabledMessage);

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        updatePositionList(_kPermissionDeniedMessage);

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      updatePositionList(_kPermissionDeniedForeverMessage);

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    updatePositionList(_kPermissionGrantedMessage);

    return true;
  }

  void updatePositionList(String displayValue) {
    if (displayValue != _kPermissionGrantedMessage) {
      _error = displayValue;
      notifyListeners();
    }
  }
}
