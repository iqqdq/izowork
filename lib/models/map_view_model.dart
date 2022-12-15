import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:izowork/api/keys.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/place_model.dart';
import 'package:izowork/entities/map_object.dart';
import 'package:izowork/views/add_map_object_widget.dart';
import 'package:izowork/views/map_object_widget.dart';
import 'package:izowork/views/search_map_object_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MapViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // CLUSTER
  Set<Marker> markers = {};
  List<Place> places = [];

  // LOCAL
  LatLng? _position;
  LatLng? _userPosition;

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

  LatLng? get userPosition {
    return _userPosition;
  }

  LatLng? get position {
    return _position;
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
    if (hasPermission && _userPosition != null) {
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _userPosition!, zoom: 16.0)));
    }
  }

  void showAddMapObjectSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.grey,
        context: context,
        builder: (context) => AddMapObjectWidget(
            address: address,
            onTap: () => {
                  // TODO ADD MAP OBJECT
                  Navigator.pop(context)
                }));
  }

  void showMapObjectSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.grey,
        context: context,
        builder: (context) => MapObjectWidget(
            mapObject: MapObject(),
            onDetailTap: () => {
                  // TODO SHOW CHAT
                },
            onChatTap: () => {
                  // TODO SHOW CHAT
                }));
  }

  void showSearchMapObjectSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.grey,
        context: context,
        builder: (context) => SearchMapObjectWidget(
            onObjectReturn: (object) => {
                  // TODO SHOW OBJECT ON MAP
                }));
  }

  // MARK: -
  // MARK: - GEOCODING

  Future getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    _userPosition = LatLng(position.latitude, position.longitude);
    _position ??= _userPosition;
  }

  void getAddressName() async {
    GoogleGeocodingApi api = GoogleGeocodingApi(google_geocoding_api_key,
        isLogged: false); // TODO - isLogged: false
    GoogleGeocodingResponse reversedSearchResults = await api.reverse(
        '${_position?.latitude}, ${_position?.longitude}',
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

  void getAddressDetails(GoogleMapController controller, String placeId) async {
    DetailsResponse? result =
        await GooglePlace(google_geocoding_api_key).details.get(placeId);
    if (result != null &&
        result.result != null &&
        result.result?.geometry != null) {
      if (result.result?.geometry?.location != null) {
        _position = LatLng(result.result!.geometry!.location!.lat!,
            result.result!.geometry!.location!.lng!);

        if (_position != null) {
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _position!, zoom: 18)));
        }
      }
    }
  }

  // MARK: -
  // MARK: - PERMISSION

  Future<void> getCurrentPosition() async {
    _hasPermission = await handlePermission();

    notifyListeners();
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

  // MARK: -
  // MARK: - LOCATIONS

  void updateMarkers(Set<Marker> markers) {
    debugPrint('Updated ${markers.length} markers');
    this.markers = markers;
    notifyListeners();
  }

  void updatePlaces() {
    if (_position != null) {
      places = [
        for (int i = 0; i < 4; i++)
          Place(
              name: 'Place $i',
              latLng: LatLng(_position!.latitude + i * 0.01,
                  _position!.longitude + i * 0.01)),
        for (int i = 0; i < 4; i++)
          Place(
              name: 'Restaraunt',
              latLng: LatLng(_position!.latitude - i * 0.01,
                  _position!.longitude + i * 0.01)),
        for (int i = 0; i < 4; i++)
          Place(
              name: 'Market',
              latLng: LatLng(_position!.latitude - i * 0.01,
                  _position!.longitude + i * 0.01)),
        for (int i = 0; i < 4; i++)
          Place(
              name: 'Place $i',
              latLng: LatLng(_position!.latitude - i * 0.01,
                  _position!.longitude + i * 0.01)),
      ];
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void onCameraMove(CameraPosition position) {
    _position = position.target;
    notifyListeners();
  }

  Future reset() async {
    loadingStatus = LoadingStatus.empty;
    _error = '';
    notifyListeners();
  }
}
