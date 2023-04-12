// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';
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
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/screens/map/map_filter_sheet/map_filter_page_view_widget.dart';
import 'package:izowork/screens/map_object/map_object_screen_widget.dart';
import 'package:izowork/screens/map_object/views/map_add_object_widget.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/search/search_screen.dart';
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
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  bool _hasPermission = false;

  // GEOCODER
  String _city = '';
  String _address = '';

  // DATA
  final List<Object> _objects = [];
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

  List<Object> get objects {
    return _objects;
  }

  String? get error {
    return _error;
  }

  MapViewModel() {
    getLocationPermission().then((value) => getObjectList());
  }

  // MARK: -
  // MARK: - API CALL

  Future getObjectList() async {
    await ObjectRepository()
        .getMapObjects(params: [])
        .then((response) => {
              if (response is List<Object>)
                {
                  loadingStatus = LoadingStatus.completed,
                  _objects.clear(),
                  _objects.addAll(response),
                  updatePlaces()
                }
              else
                loadingStatus = LoadingStatus.error
            })
        .then((value) => updatePlaces());
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
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }

  void showAddMapObjectSheet(BuildContext context, LatLng position) {
    getAddressName().then((value) => {
          showCupertinoModalBottomSheet(
              topRadius: const Radius.circular(16.0),
              barrierColor: Colors.black.withOpacity(0.6),
              backgroundColor: HexColors.white,
              context: context,
              builder: (context) => MapAddObjectWidget(
                  address: address,
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ObjectCreateScreenWidget(
                                    address: address,
                                    lat: position.latitude,
                                    long: position.longitude,
                                    onCreate: (object) => {
                                          Toast().showTopToast(context,
                                              '${Titles.object} ${object.name} добавлен!'),
                                          getObjectList()
                                        })))
                      }))
        });
  }

  void showMapObjectSheet(BuildContext context, String id) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => MapObjectScreenWidget(
            object: objects.firstWhere((element) => element.id == id)));
  }

  void showSearchMapObjectSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchScreenWidget(
            isRoot: true,
            searchType: SearchType.object,
            onPop: () => {
                  // TODO SET PRODUCT
                }));
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

  Future getAddressName() async {
    bool isDebugMode = true;

    GoogleGeocodingApi api =
        GoogleGeocodingApi(google_map_api_key, isLogged: isDebugMode);

    GoogleGeocodingResponse reversedSearchResults = await api.reverse(
        '${_position?.latitude}, ${_position?.longitude}',
        language: locale);

    if (reversedSearchResults.status == 'REQUEST_DENIED') {
      log('Problem with Geocoding API');
      return;
    }

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
        await GooglePlace(google_map_api_key).details.get(placeId);
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
    places.clear();

    if (objects.isNotEmpty) {
      objects.forEach((element) {
        places.add(
            Place(name: element.id, latLng: LatLng(element.lat, element.long)));
      });
    }

    //  places = [
    //     Place(
    //         name: 'Place',
    //         latLng: LatLng(55.828649551928535, 49.13686567701648)),
    //     Place(
    //         name: 'Place',
    //         latLng: LatLng(55.83017411585656, 49.13622194684715)),
    //     Place(
    //         name: 'Place',
    //         latLng: LatLng(55.82811925481553, 49.13495594418079)),
    //     Place(
    //         name: 'Place',
    //         latLng: LatLng(55.82781192022498, 49.13759523787506)),
    //   ];
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void onCameraMove(CameraPosition position) {
    _position = position.target;
    getObjectList();
  }
}
