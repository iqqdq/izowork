import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as cluster_manager;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:izowork/features/map/view_model/map_view_model.dart';
import 'package:izowork/features/map_company/view/map_company_screen_widget.dart';
import 'package:izowork/izowork_app.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/views/views.dart';
import 'package:izowork/features/companies/view/companies_filter_sheet/companies_filter_page_view_screen.dart';
import 'package:izowork/features/company_create/view/company_create_screen.dart';
import 'package:izowork/features/map/view/views/map_control_widget.dart';
import 'package:izowork/features/map_object/view/map_object_screen_widget.dart';
import 'package:izowork/features/map_object/view/views/map_add_object_widget.dart';
import 'package:izowork/features/object_create/view/object_create_screen.dart';
import 'package:izowork/features/objects/view/objects_filter_sheet/objects_filter_page_view_screen.dart';
import 'package:izowork/features/search_company/view/search_company_screen.dart';
import 'package:izowork/features/search_object/view/search_object_screen.dart';

class MapScreenBodyWidget extends StatefulWidget {
  const MapScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _MapScreenBodyState createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<MapScreenBodyWidget>
    with AutomaticKeepAliveClientMixin, RouteAware {
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController _googleMapController;

  late MapViewModel _mapViewModel;

  cluster_manager.ClusterManager? _clusterManager;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    _updateMarkers(isObjectMarkers: _mapViewModel.isObjectMarkers);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _mapViewModel = Provider.of<MapViewModel>(
      context,
      listen: true,
    );

    if (_clusterManager == null && _mapViewModel.objects.isNotEmpty) {
      _updateClusterManager();
    }

    return SizedBox.expand(
      child: Stack(children: [
        /// GOOGLE MAP
        GoogleMap(
          compassEnabled: false,
          tiltGesturesEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: _mapViewModel.isLocationPermissionEnabled,
          initialCameraPosition: CameraPosition(
            target: _mapViewModel.cameraPosition,
            zoom: 20.0,
          ),
          markers: _mapViewModel.markers,
          onMapCreated: (controller) => {
            _googleMapController = controller,
            _completer.complete(controller),
            _mapViewModel.handlePermission().whenComplete(
                  () => _mapViewModel
                      .getUserLocation()
                      .whenComplete(() => _showUserLocation()),
                )
          },
          onCameraMove: (position) {
            _mapViewModel.onCameraMove(position);
            _clusterManager?.onCameraMove(position);
          },
          onCameraIdle: () =>
              _updateMarkers(isObjectMarkers: _mapViewModel.isObjectMarkers),
          onLongPress: (position) => _showMapAddObjectSheet(position: position),
        ),

        /// SEGMENTED CONTROL
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: 8.0,
                top: Platform.isAndroid ||
                        MediaQuery.of(context).padding.top == 0.0
                    ? 12.0
                    : 0.0,
              ),
              child: SegmentedControlWidget(
                titles: const [
                  Titles.objects,
                  Titles.clients,
                ],
                width: 212.0,
                backgroundColor: HexColors.grey10,
                activeColor: HexColors.black,
                disableColor: HexColors.grey40,
                thumbColor: HexColors.white,
                borderColor: HexColors.grey20,
                onTap: (index) => _switchMarkers(index: index),
              ),
            ),
          ),
        ),

        /// MAP CONTROL
        Align(
          alignment: Alignment.centerRight,
          child: MapControlWidget(
            onZoomInTap: () => _zoomIn(),
            onZoomOutTap: () => _zoomOut(),
            onShowLocationTap: () => _mapViewModel.isLocationPermissionEnabled
                ? _showUserLocation()
                : {},
            onSearchTap: () => _showSearchMapObjectSheet(),
          ),
        ),

        /// FILTER BUTTON
        Align(
          alignment: Alignment.bottomCenter,
          child: FilterButtonWidget(
            isSelected: _mapViewModel.isObjectMarkers
                ? _mapViewModel.objectsFilter != null
                : _mapViewModel.companiesFilter != null,
            onTap: () => _showFilterSheet(),
          ),
        )
      ]),
    );
  }

  // MARK: -
  // MARK: - CLUSTER FUNCTIONS

  Future<Marker> Function(dynamic) get _markerBuilder => (cluster) async {
        final cluster_manager.Cluster<Place> clusterPlace = cluster;

        return Marker(
          markerId: MarkerId(clusterPlace.getId()),
          position: clusterPlace.location,
          onTap: () async {
            if (clusterPlace.isMultiple) {
              if ((cluster.items as List).length > 10) {
                _googleMapController.getZoomLevel().then((value) =>
                    _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: clusterPlace.location,
                      zoom: value + 1.25,
                    ))));
              } else {
                // create points for the bounds
                double north = cluster.location.latitude;
                double south = cluster.location.latitude;
                double east = cluster.location.longitude;
                double west = cluster.location.longitude;

                // extend the bound points with the markers in the cluster
                for (var clusterMarker in cluster.items) {
                  south = min(south, clusterMarker.location.latitude);
                  north = max(north, clusterMarker.location.latitude);
                  west = min(west, clusterMarker.location.longitude);
                  east = max(east, clusterMarker.location.longitude);
                }

                // create the CameraUpdate with LatLngBounds
                CameraUpdate clusterView = CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                        southwest: LatLng(south, west),
                        northeast: LatLng(north, east)),
                    32 // this is the padding to add on top of the bounds
                    );

                // set the new view
                _googleMapController.animateCamera(clusterView);
              }
            } else {
              await _googleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: clusterPlace.location,
                zoom: 20.0,
              )));

              _showMarkerSheet(id: clusterPlace.items.first.id);
            }
          },
          icon: _mapViewModel.isObjectMarkers
              ? await MarkerHelper().getObjectMarkerBitmap(
                  cluster.isMultiple ? 48 : 40,
                  cluster,
                )
              : await MarkerHelper().getCompanyMarkerBitmap(
                  cluster.isMultiple ? 48 : 40,
                  cluster,
                ),
        );
      };

  void _updateClusterManager() {
    _clusterManager = ClusterHelper().initClusterManager(
      places: _mapViewModel.places,
      updateMarkers: _mapViewModel.updateMarkers,
      markerBuilder: _markerBuilder,
    );

    _clusterManager?.setMapId(_googleMapController.mapId);
  }

  Future _updateMarkers({required bool isObjectMarkers}) async {
    EasyDebounce.debounce('marker_debouncer', const Duration(milliseconds: 500),
        () async {
      isObjectMarkers
          ? await _mapViewModel.getObjectList(
              latLngBounds: await _googleMapController.getVisibleRegion())
          : await _mapViewModel.getCompanyList(
              latLngBounds: await _googleMapController.getVisibleRegion());

      _clusterManager?.setItems(_mapViewModel.places);
    });
  }

  // MARK: -
  // MARK: - MAP CONTROL ACTIONS

  void _switchMarkers({required int index}) async {
    _mapViewModel.places.clear();

    await _mapViewModel.changeMarkerType(index: index).whenComplete(() {
      _updateClusterManager();
      _updateMarkers(isObjectMarkers: _mapViewModel.isObjectMarkers);
    });
  }

  Future _zoomIn() async {
    _googleMapController.getZoomLevel().then((value) => _googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _mapViewModel.cameraPosition,
          zoom: value + 1.0,
        ))));

    double zoom = await _googleMapController.getZoomLevel();
    debugPrint('Current zoom is: $zoom');
  }

  Future _zoomOut() async {
    _googleMapController.getZoomLevel().then((value) => _googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _mapViewModel.cameraPosition,
          zoom: value - 1.0,
        ))));

    double zoom = await _googleMapController.getZoomLevel();
    debugPrint('Current zoom is: $zoom');
  }

  void _showUserLocation() {
    if (_mapViewModel.isLocationPermissionEnabled) {
      _mapViewModel.getUserLocation().whenComplete(
            () => _googleMapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: _mapViewModel.cameraPosition,
              zoom: 20.0,
            ))),
          );
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _showObject(MapObject? object) {
    bool found = false;

    Future.delayed(
        const Duration(milliseconds: 500),
        () => {
              if (object != null)
                {
                  for (var element in _mapViewModel.objects)
                    {
                      if (object.id == element.id) found = true,
                    },
                  if (found)
                    {
                      _mapViewModel.objects
                          .removeWhere((element) => element.id == object.id),
                    },
                  _mapViewModel.objects.add(object),
                  _mapViewModel.updatePlaces().whenComplete(() =>
                      _googleMapController
                          .animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            object.lat,
                            object.long,
                          ),
                          zoom: 20.0,
                        ),
                      )))
                }
            });
  }

  void _showCompany(Company? company) {
    bool found = false;

    Future.delayed(
        const Duration(milliseconds: 500),
        () => {
              if (company != null)
                {
                  for (var element in _mapViewModel.companies)
                    {
                      if (company.id == element.id) found = true,
                    },
                  if (found)
                    {
                      _mapViewModel.companies
                          .removeWhere((element) => element.id == company.id),
                    },
                  _mapViewModel.companies.add(company),
                  _mapViewModel.updatePlaces().whenComplete(() {
                    if (company.lat != null && company.long != null) {
                      _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(
                            company.lat!,
                            company.long!,
                          ),
                          zoom: 20.0,
                        )),
                      );
                    } else {
                      Toast().showTopToast(
                          '${company.name} не добавлен на карту!');
                    }
                  })
                }
            });
  }

  // MARK: -
  // MARK: - PUSH

  void _showMarkerSheet({required String id}) => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => _mapViewModel.isObjectMarkers
            ? MapObjectScreenWidget(
                object: _mapViewModel.objects.firstWhere(
                  (element) => element.id == id,
                ),
              )
            : MapCompanyScreenWidget(
                company: _mapViewModel.companies
                    .firstWhere((element) => element.id == id),
              ),
      );

  void _showFilterSheet() async {
    LatLngBounds? latLngBounds = await _googleMapController.getVisibleRegion();

    if (_mapViewModel.objectStages != null) {
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withValues(alpha: 0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => _mapViewModel.isObjectMarkers
              ? ObjectsFilterPageViewScreenWidget(
                  objectStages: _mapViewModel.objectStages ?? [],
                  objectsFilter: _mapViewModel.objectsFilter,
                  onPop: (filter) => {
                    filter == null
                        ? _mapViewModel.resetFilter()
                        : _mapViewModel.setObjectsFilter(filter: filter),
                    _mapViewModel
                        .getObjectList(latLngBounds: latLngBounds)
                        .whenComplete(() => _updateMarkers(
                            isObjectMarkers: _mapViewModel.isObjectMarkers)),
                  },
                )
              : CompaniesFilterPageViewScreenWidget(
                  companiesFilter: _mapViewModel.companiesFilter,
                  onPop: (filter) => {
                    filter == null
                        ? _mapViewModel.resetFilter()
                        : _mapViewModel.setCompaniesFilter(filter: filter),
                    _mapViewModel
                        .getCompanyList(latLngBounds: latLngBounds)
                        .whenComplete(() => _updateMarkers(
                            isObjectMarkers: _mapViewModel.isObjectMarkers)),
                  },
                ));
    }
  }

  Future _showMapAddObjectSheet({required LatLng position}) async {
    String address = await _mapViewModel.getAddress() ?? '';

    await _mapViewModel
        .setPosition(position: position)
        .whenComplete(() => showCupertinoModalBottomSheet(
              enableDrag: false,
              topRadius: const Radius.circular(16.0),
              barrierColor: Colors.black.withValues(alpha: 0.6),
              backgroundColor: HexColors.white,
              context: context,
              builder: (sheetContext) => MapAddObjectScreenWidget(
                  title: _mapViewModel.isObjectMarkers == true
                      ? Titles.addObject
                      : Titles.addClient,
                  address: address,
                  onTap: () => {
                        Navigator.pop(context),
                        Future.delayed(
                          const Duration(milliseconds: 500),
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    _mapViewModel.isObjectMarkers == true
                                        ? ObjectCreateScreenWidget(
                                            address: address,
                                            lat: position.latitude,
                                            long: position.longitude,
                                            onPop: (object) =>
                                                _showObject(object),
                                          )
                                        : CompanyCreateScreenWidget(
                                            address: address,
                                            lat: position.latitude,
                                            long: position.longitude,
                                            onPop: (company) =>
                                                _showCompany(company),
                                          ),
                              )),
                        )
                      }),
            ));
  }

  void _showSearchMapObjectSheet() => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withValues(alpha: 0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => _mapViewModel.isObjectMarkers == true

          /// SEARCH OBJECT
          ? SearchObjectScreenWidget(
              isRoot: true,
              title: Titles.object,
              onFocus: () => {},
              onPop: (object) => {
                    Navigator.pop(context),
                    _showObject(object),
                  })

          /// SEARCH COMPANY
          : SearchCompanyScreenWidget(
              isRoot: true,
              title: Titles.client,
              onFocus: () => {},
              onPop: (company) => {
                Navigator.pop(context),
                _showCompany(company),
              },
            ));
}
