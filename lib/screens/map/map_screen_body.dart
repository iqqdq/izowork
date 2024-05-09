import 'dart:async';
import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen.dart';
import 'package:izowork/screens/company_create/company_create_screen.dart';
import 'package:izowork/screens/map/helpers/bounds_helper.dart';
import 'package:izowork/screens/map/helpers/cluster_helper.dart';
import 'package:izowork/screens/map/helpers/marker_helper.dart';
import 'package:izowork/screens/map/views/map_control_widget.dart';
import 'package:izowork/screens/map_company/map_object_screen_widget.dart';
import 'package:izowork/screens/map_object/map_object_screen_widget.dart';
import 'package:izowork/screens/map_object/views/map_add_object_widget.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_object/search_object_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class MapScreenBodyWidget extends StatefulWidget {
  const MapScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _MapScreenBodyState createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<MapScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController _googleMapController;

  late MapViewModel _mapViewModel;
  ClusterManager? _clusterManager;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - MAP FUNCTIONS

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            debugPrint('---- $cluster');

            if (cluster.isMultiple) {
              LatLngBounds? bounds = BoundsHelper().getBounds(cluster.items
                  .map(
                    (marker) => LatLng(
                      marker.location.latitude,
                      marker.location.longitude,
                    ),
                  )
                  .toList());

              await _googleMapController
                  .animateCamera(CameraUpdate.newLatLngBounds(
                bounds,
                40.0,
              ));
            } else {
              await _googleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                    target: cluster.location,
                    zoom: 20.0,
                  )))
                  .whenComplete(
                      () => _showMarkerSheet(id: cluster.items.first.id));
            }
          },
          icon: _mapViewModel.isObjectMarkers
              ? await MarkerHelper().getObjectMarkerBitmap(
                  cluster.isMultiple ? 160 : 120,
                  cluster,
                )
              : await MarkerHelper().getCompanyMarkerBitmap(
                  cluster.isMultiple ? 160 : 120,
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
              latLngBounds: await _googleMapController
                  .getVisibleRegion()
                  .whenComplete(() => _updateClusters()))
          : await _mapViewModel.getCompanyList(
              latLngBounds: await _googleMapController
                  .getVisibleRegion()
                  .whenComplete(() => _updateClusters()));
    });
  }

  void _updateClusters() {
    _mapViewModel
        .updatePlaces()
        .then((value) => _clusterManager?.setItems(_mapViewModel.places));
  }

  // MARK: -
  // MARK: - ACTIONS

  void _switchMarkers({required int index}) async {
    await _mapViewModel.changeMarkerType(index: index).whenComplete(() {
      _updateClusterManager();
      _updateMarkers(isObjectMarkers: _mapViewModel.isObjectMarkers);
    });
  }

  Future _zoomIn() async {
    if (_mapViewModel.position != null) {
      _googleMapController.getZoomLevel().then((value) => _googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: _mapViewModel.position!,
            zoom: value + 1.0,
          ))));

      double zoom = await _googleMapController.getZoomLevel();
      debugPrint('Current zoom is: $zoom');
    }
  }

  Future _zoomOut() async {
    if (_mapViewModel.position != null) {
      _googleMapController.getZoomLevel().then((value) => _googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: _mapViewModel.position!,
            zoom: value - 1.0,
          ))));

      double zoom = await _googleMapController.getZoomLevel();
      debugPrint('Current zoom is: $zoom');
    }
  }

  void _showUserLocation() {
    if (_mapViewModel.userPosition != null) {
      _googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _mapViewModel.userPosition!,
        zoom: 20.0,
      )));
    }
  }

  // MARK: -
  // MARK: - PUSH

  void _showMarkerSheet({required String id}) => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => _mapViewModel.isObjectMarkers
            ? MapObjectScreenWidget(
                object: _mapViewModel.objects.firstWhere(
                  (element) => element.id == id,
                ),
              )
            : MapCompanyScreenWidget(
                company: _mapViewModel.companies.firstWhere(
                  (element) => element.id == id,
                ),
              ),
      );

  void _showFilterSheet() async {
    LatLngBounds? latLngBounds = await _googleMapController.getVisibleRegion();

    if (_mapViewModel.objectStages != null) {
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
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
    await _mapViewModel
        .setPosition(position: position)
        .whenComplete(() => showCupertinoModalBottomSheet(
              enableDrag: false,
              topRadius: const Radius.circular(16.0),
              barrierColor: Colors.black.withOpacity(0.6),
              backgroundColor: HexColors.white,
              context: context,
              builder: (sheetContext) => MapAddObjectScreenWidget(
                title: _mapViewModel.isObjectMarkers == true
                    ? Titles.addObject
                    : Titles.addClient,
                address: _mapViewModel.address,
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
                                      address: _mapViewModel.address,
                                      lat: position.latitude,
                                      long: position.longitude,
                                      onPop: (object) => {
                                            if (object != null)
                                              _mapViewModel.getObjectList(),
                                          })
                                  : CompanyCreateScreenWidget(
                                      address: _mapViewModel.address,
                                      lat: position.latitude,
                                      long: position.longitude,
                                      onPop: (company) => {
                                            if (company != null)
                                              _mapViewModel.getCompanyList(),
                                          }),
                        )),
                  )
                },
              ),
            ));
  }

  void _showSearchMapObjectSheet() {
    bool found = false;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => _mapViewModel.isObjectMarkers

            /// SEARCH OBJECT
            ? SearchObjectScreenWidget(
                isRoot: true,
                title: Titles.object,
                onFocus: () => {},
                onPop: (object) => {
                  Navigator.pop(context),
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
                                    _mapViewModel.objects.removeWhere(
                                        (element) => element.id == object.id),
                                  },
                                _mapViewModel.objects.add(object),
                                _mapViewModel.updatePlaces().whenComplete(
                                      () => _googleMapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(
                                            object.lat,
                                            object.long,
                                          ),
                                          zoom: 20.0,
                                        ),
                                      )),
                                    )
                                // .whenComplete(
                                //   () => Future.delayed(
                                //       const Duration(seconds: 1),
                                //       () =>
                                //           _showMarkerSheet(id: object.id)),
                                // )
                              }
                          })
                },
              )

            /// SEARCH COMPANY
            : SearchCompanyScreenWidget(
                isRoot: true,
                title: Titles.client,
                onFocus: () => {},
                onPop: (company) => {
                  Navigator.pop(context),
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
                                    _mapViewModel.companies.removeWhere(
                                        (element) => element.id == company.id),
                                  },
                                _mapViewModel.companies.add(company),
                                _mapViewModel
                                    .updatePlaces()
                                    .whenComplete(() => {
                                          if (company.lat != null &&
                                              company.long != null)
                                            _googleMapController.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                target: LatLng(
                                                  company.lat!,
                                                  company.long!,
                                                ),
                                                zoom: 20.0,
                                              )),
                                            )
                                          else
                                            Toast().showTopToast(context,
                                                '${company.name} не добавлен на карту!')
                                        })
                                // .whenComplete(
                                //   () => Future.delayed(
                                //       const Duration(seconds: 1),
                                //       () =>
                                //           _showMarkerSheet(id: company.id)),
                                // )
                              }
                          })
                },
              ));
  }

  // MARK: -
  // MARK: - BUILD

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _mapViewModel = Provider.of<MapViewModel>(
      context,
      listen: true,
    );

    return SizedBox.expand(
      child: Stack(children: [
        /// GOOGLE MAP
        _mapViewModel.userPosition == null
            ? Container()
            : GoogleMap(
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: _mapViewModel.hasPermission,
                initialCameraPosition: CameraPosition(
                  target: _mapViewModel.userPosition!,
                  zoom: 20.0,
                ),
                markers: _mapViewModel.markers,
                onMapCreated: (controller) => {
                  _googleMapController = controller,
                  _completer.complete(controller),
                  _updateClusterManager(),
                  _updateMarkers(isObjectMarkers: _mapViewModel.isObjectMarkers)
                },
                onCameraMove: (position) => {
                  _mapViewModel.onCameraMove(position),
                  _clusterManager?.onCameraMove(position),
                },
                onCameraIdle: () => _updateMarkers(
                    isObjectMarkers: _mapViewModel.isObjectMarkers),
                onLongPress: (position) =>
                    _showMapAddObjectSheet(position: position),
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
            onShowLocationTap: () => _mapViewModel.hasPermission &&
                    _mapViewModel.userPosition != null
                ? _showUserLocation()
                : _mapViewModel.getLocationPermission(),
            onSearchTap: () => _showSearchMapObjectSheet(),
          ),
        ),

        /// FILTER BUTTON
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: FilterButtonWidget(
              onTap: () => _showFilterSheet(),
            ),
          ),
        )
      ]),
    );
  }
}
