import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:izowork/api/keys.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/companies/view/companies_filter_sheet/companies_filter_page_view_screen_body.dart';
import 'package:izowork/features/objects/view/objects_filter_sheet/objects_filter_page_view_screen_body.dart';

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

  LatLng _cameraPosition = const LatLng(
    51.15935891650487,
    71.46291020823648,
  );

  LatLng get cameraPosition => _cameraPosition;

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

    await sl<ObjectRepositoryInterface>()
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
    await sl<ObjectRepositoryInterface>()
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
            })
        .whenComplete(() async => await updatePlaces());
  }

  Future getCompanyList({LatLngBounds? latLngBounds}) async {
    await sl<CompaniesRepositoryInterface>()
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
                }
              else
                loadingStatus = LoadingStatus.error
            })
        .whenComplete(() async => await updatePlaces());
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

      _cameraPosition = LatLng(position.latitude, position.longitude);

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
              ? HexColors.additionalRed.withValues(alpha: 0.75)
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

  Future<String?> getAddress() async {
    GoogleGeocodingResponse googleGeocodingResponse = await GoogleGeocodingApi(
      google_map_api_key,
      isLogged: false,
    ).reverse(
      '${_cameraPosition.latitude}, ${_cameraPosition.longitude}',
      language: Platform.localeName,
    );

    // String? country;
    String? city;
    String? streetName;
    String? streetNumber;

    Iterable<GoogleGeocodingAddressComponent> addressComponents =
        googleGeocodingResponse.results.first.addressComponents;

    for (var component in addressComponents) {
      // if (component.types.contains('country')) {
      //   country = component.longName;
      // }

      if (component.types.contains('locality')) {
        city = component.longName;
      }

      if (component.types.contains('route')) {
        streetName = component.shortName;
      }

      if (component.types.contains('street_number')) {
        streetNumber = component.longName;
      }
    }

    String address = '';

    address += city == null
        ? ''
        : streetName == null
            ? city
            : '$city, ';

    address += streetName == null
        ? ''
        : streetNumber == null
            ? streetName
            : '$streetName ';

    address += streetNumber ?? '';

    return address;
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future changeMarkerType({required int index}) async {
    _isObjectMarkers = index == 0 ? true : false;
    notifyListeners();
  }

  Future setPosition({required LatLng position}) async {
    _cameraPosition = position;
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
