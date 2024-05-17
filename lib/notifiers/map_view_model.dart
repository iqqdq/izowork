import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:izowork/api/keys.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen_body.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen_body.dart';

class MapViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  bool _isObjectMarkers = true;

  bool get isObjectMarkers => _isObjectMarkers;

  // PERMISSION

  bool _isServicesEnabled = false;

  bool get isServicesEnabled => _isServicesEnabled;

  bool _isLocationPermissionEnabled = false;

  bool get isLocationPermissionEnabled => _isLocationPermissionEnabled;

  // CLUSTER MANAGER

  Set<Marker> markers = {};

  List<Place> places = [];

  // POSITION'S

  LatLng _cameraPosition = const LatLng(51.15935891650487, 71.46291020823648);

  LatLng get cameraPosition => _cameraPosition;

  LatLng? _userPosition;

  LatLng? get userPosition => _userPosition;

  // GEOCODER

  String? _address;

  String? get address => _address;

  // FILTER

  ObjectsFilter? _objectsFilter;

  ObjectsFilter? get objectsFilter => _objectsFilter;

  CompaniesFilter? _companiesFilter;

  CompaniesFilter? get companiesFilter => _companiesFilter;

  // DATA

  List<ObjectStage>? _objectStages;

  List<ObjectStage>? get objectStages => _objectStages;

  final List<MapObject> _objects = [];

  List<MapObject> get objects => _objects;

  final List<Company> _companies = [];

  List<Company> get companies => _companies;

  MapViewModel() {
    _getObjectStageList();
  }

  // MARK: -
  // MARK: - API CALL

  Future _getObjectStageList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository()
        .getObjectStages()
        .then((response) => {
              if (response is List<ObjectStage>)
                {
                  _objectStages = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future getObjectList({LatLngBounds? latLngBounds}) async {
    await ObjectRepository()
        .getMapObjects(
          params: _objectsFilter?.params ?? [],
          visibleRegion: latLngBounds,
        )
        .then((response) => {
              if (response is List<MapObject>)
                {
                  loadingStatus = LoadingStatus.completed,
                  _objects.clear(),
                  _objects.addAll(response),
                  updatePlaces()
                }
              else
                loadingStatus = LoadingStatus.error
            });
  }

  Future getCompanyList({LatLngBounds? latLngBounds}) async {
    await CompanyRepository()
        .getMapCompanies(
          params: _objectsFilter?.params ?? [],
          visibleRegion: latLngBounds,
        )
        .then((response) => {
              if (response is List<Company>)
                {
                  loadingStatus = LoadingStatus.completed,
                  _companies.clear(),
                  _companies.addAll(response),
                  updatePlaces()
                }
              else
                loadingStatus = LoadingStatus.error
            });
  }

  // MARK: -
  // MARK: - PERMISSION

  Future handlePermission() async {
    final geolocatorPlatform = GeolocatorPlatform.instance;
    _isServicesEnabled = await geolocatorPlatform.isLocationServiceEnabled();

    if (_isServicesEnabled) {
      var permission = await geolocatorPlatform.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await geolocatorPlatform.requestPermission();

        if (permission == LocationPermission.denied) {
          _isLocationPermissionEnabled = false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _isLocationPermissionEnabled = false;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        _isLocationPermissionEnabled = true;
      }
    }

    notifyListeners();
  }

  Future getUserLocation() async {
    if (_isLocationPermissionEnabled) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      _userPosition = LatLng(position.latitude, position.longitude);
      _cameraPosition = _userPosition ?? _cameraPosition;

      notifyListeners();
    }
  }

  // MARK: -
  // MARK: - CLUSTER MANAGER

  void updateMarkers(Set<Marker> markers) {
    debugPrint('Updated ${markers.length} markers');
    this.markers = markers;

    updatePlaces();
  }

  Future updatePlaces() async {
    places.clear();

    if (_isObjectMarkers == true) {
      for (var object in _objects) {
        places.add(Place(
          id: object.id,
          name: object.manager?.name ?? '-',
          color: object.hasOverdueTask == true
              ? HexColors.additionalRed.withOpacity(0.75)
              : object.objectStage?.color == null
                  ? HexColors.primaryMain
                  : HexColor(object.objectStage!.color!),
          latLng: LatLng(
            object.lat,
            object.long,
          ),
        ));
      }
    } else {
      for (var company in _companies) {
        if (company.lat != null && company.long != null) {
          places.add(
            Place(
                id: company.id,
                name: company.manager?.name ?? '-',
                color: company.type == 'Поставщик'
                    ? HexColors.additionalViolet
                    : company.type == 'Проектировщик'
                        ? HexColors.additionalDeepBlue
                        : HexColors.grey70,
                latLng: LatLng(
                  company.lat!,
                  company.long!,
                )),
          );
        }
      }
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - GEOCODING

  Future<String?> _getAddress() async => (await GoogleGeocodingApi(
        google_map_api_key,
        isLogged: false,
      ).reverse(
        '${_cameraPosition.latitude}, ${_cameraPosition.longitude}',
        language: Platform.localeName,
      ))
          .results
          .first
          .formattedAddress;

  void getAddressDetails(
    GoogleMapController controller,
    String placeId,
  ) async {
    final result = await GooglePlace(google_map_api_key).details.get(placeId);

    if (result?.result?.geometry?.location != null) {
      _cameraPosition = LatLng(
        result!.result!.geometry!.location!.lat!,
        result.result!.geometry!.location!.lng!,
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _cameraPosition,
        zoom: 18,
      )));
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future changeMarkerType({required int index}) async {
    _isObjectMarkers = index == 0 ? true : false;

    notifyListeners();
  }

  Future setPosition({required LatLng position}) async {
    _cameraPosition = position;
    _address = await _getAddress();

    notifyListeners();
  }

  void onCameraMove(CameraPosition position) =>
      _cameraPosition = position.target;

  void setObjectsFilter({required ObjectsFilter filter}) =>
      _objectsFilter = filter;

  void setCompaniesFilter({required CompaniesFilter filter}) =>
      _companiesFilter = filter;

  void resetFilter() =>
      _isObjectMarkers ? _objectsFilter = null : _companiesFilter = null;
}
