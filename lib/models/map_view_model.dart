import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:izowork/api/keys.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen_body.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen_body.dart';

class MapViewModel with ChangeNotifier {
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

  bool _isObjectMarkers = true;

  // GEOCODER
  String _address = '';

  // DATA
  final List<Object> _objects = [];

  List<ObjectStage>? _objectStages;

  ObjectsFilter? _objectsFilter;

  final List<Company> _companies = [];

  CompaniesFilter? _companiesFilter;

  bool get hasPermission => _hasPermission;

  LatLng? get userPosition => _userPosition;

  LatLng? get position => _position;

  bool get isObjectMarkers => _isObjectMarkers;

  String get address => _address;

  List<Object> get objects => _objects;

  ObjectsFilter? get objectsFilter => _objectsFilter;

  List<ObjectStage>? get objectStages => _objectStages;

  List<Company> get companies => _companies;

  CompaniesFilter? get companiesFilter => _companiesFilter;

  MapViewModel() {
    getLocationPermission()
        .then((value) => getStageList().then((value) => getObjectList()));
  }

  // MARK: -
  // MARK: - API CALL

  Future getStageList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository()
        .getObjectStages()
        .then((response) => {
              if (response is List<ObjectStage>) {_objectStages = response}
            })
        .then((value) => getObjectList());
  }

  Future getObjectList({LatLngBounds? latLngBounds}) async {
    await ObjectRepository()
        .getMapObjects(
          params: _objectsFilter?.params ?? [],
          visibleRegion: latLngBounds,
        )
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
  // MARK: - GEOCODING

  Future getUserLocation() async {
    if (hasPermission) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      _userPosition = LatLng(position.latitude, position.longitude);
    } else {
      _userPosition = const LatLng(51.15935891650487, 71.46291020823648);
    }

    _position ??= _userPosition;

    notifyListeners();
  }

  Future getAddressName() async {
    bool isDebugMode = false;

    GoogleGeocodingApi api =
        GoogleGeocodingApi(google_map_api_key, isLogged: isDebugMode);

    GoogleGeocodingResponse reversedSearchResults = await api.reverse(
      '${_position?.latitude}, ${_position?.longitude}',
      language: Platform.localeName,
    );

    if (reversedSearchResults.status == 'REQUEST_DENIED') {
      log('Problem with Geocoding API');
      return;
    }

    // SET FORMATTED ADDRESS
    _address = reversedSearchResults.results.first.formattedAddress;

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
          controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: _position!,
            zoom: 18,
          )));
        }
      }
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

    updatePlaces();
  }

  Future updatePlaces() async {
    places.clear();

    if (_isObjectMarkers == true) {
      for (var object in _objects) {
        places.add(
          Place(
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
          ),
        );
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
              ),
            ),
          );
        }
      }
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future changeMarkerType({required int index}) async {
    _isObjectMarkers = index == 0 ? true : false;
    notifyListeners();
  }

  Future setPosition({required LatLng position}) async {
    _position = position;
    await getAddressName();
  }

  void onCameraMove(CameraPosition position) => _position = position.target;

  void setObjectsFilter({required ObjectsFilter filter}) =>
      _objectsFilter = filter;

  void setCompaniesFilter({required CompaniesFilter filter}) =>
      _companiesFilter = filter;

  void resetFilter() =>
      _isObjectMarkers ? _objectsFilter = null : _companiesFilter = null;
}
