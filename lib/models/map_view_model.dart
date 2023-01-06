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
import 'package:izowork/screens/map/map_object_sheet/map_add_object_widget.dart';
import 'package:izowork/screens/map/map_object_sheet/map_object_widget.dart';
import 'package:izowork/screens/map/map_search_sheet/map_search_object_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../screens/map/map_filter_sheet/map_filter_page_view_widget.dart';

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

  // GEOCODER
  String _city = '';
  String _address = '';

  // DATA
  String? _error;

  bool get hasPermission {
    return _hasPermission;
  }

  LatLng? get userPosition {
    return _userPosition;
  }

  LatLng? get position {
    return _position;
  }

  String get city {
    return _city;
  }

  String get address {
    return _address;
  }

  String? get error {
    return _error;
  }

  MapViewModel() {
    getLocationPermission();
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

  // MARK: -
  // MARK: - PUSH

  void showMapFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => MapFilterPageViewWidget(
            onApplyTap: () => {}, onResetTap: () => {}));
  }

  void showAddMapObjectSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => MapAddObjectWidget(
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
        backgroundColor: HexColors.white,
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
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => MapSearchObjectWidget(
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

    updatePlaces();
  }

  Future getAddressName() async {
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

  Future updatePlaces() async {
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
