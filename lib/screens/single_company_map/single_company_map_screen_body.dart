import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/map/views/map_control_widget.dart';
import 'package:izowork/screens/map_company/map_object_screen_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:izowork/models/models.dart';

class SingleCompanyMapScreenBodyWidget extends StatefulWidget {
  const SingleCompanyMapScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _SingleCompanyMapScreenBodyState createState() =>
      _SingleCompanyMapScreenBodyState();
}

class _SingleCompanyMapScreenBodyState
    extends State<SingleCompanyMapScreenBodyWidget> {
  late GoogleMapController _googleMapController;

  late SingleCompanyMapViewModel _singleCompanyMapViewModel;
  ClusterManager? _clusterManager;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - CLUSTER FUNCTIONS

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(_singleCompanyMapViewModel.places,
        _singleCompanyMapViewModel.updateMarkers,
        markerBuilder: _markerBuilder);
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            debugPrint('---- $cluster');

            await _googleMapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: cluster.location,
              zoom: 20.0,
            )));

            _pushMapObjectScreenWidget();
          },
          icon: await MarkerHelper().getCompanyMarkerBitmap(
            120,
            cluster,
          ),
        );
      };

  void _updateMap() async {
    _clusterManager?.setItems(_singleCompanyMapViewModel.places);
    _clusterManager?.updateMap();

    Future.delayed(const Duration(seconds: 1), () => setState(() {}));
  }

  // MARK: -
  // MARK: - PUSH

  void _pushMapObjectScreenWidget() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () => showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => MapCompanyScreenWidget(
                company: _singleCompanyMapViewModel.company,
                hideInfoButton: true,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _singleCompanyMapViewModel = Provider.of<SingleCompanyMapViewModel>(
      context,
      listen: true,
    );

    _clusterManager ??= _initClusterManager();

    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_singleCompanyMapViewModel.company.name,
                      style: TextStyle(
                        color: HexColors.black,
                        fontSize: 18.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.bold,
                      )),
                ])
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// GOOGLE MAP
          GoogleMap(
              compassEnabled: false,
              tiltGesturesEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: _singleCompanyMapViewModel.hasPermission,
              initialCameraPosition: CameraPosition(
                target: _singleCompanyMapViewModel.places.first.latLng,
                zoom: 20.0,
              ),
              markers: _singleCompanyMapViewModel.markers,
              onMapCreated: (controller) => {
                    _googleMapController = controller,

                    /// SET CLUSTER ID
                    _clusterManager?.setMapId(_googleMapController.mapId),

                    /// UPDATE LOCATION
                    _updateMap()
                  },
              onCameraIdle: () => _updateMap(),
              onCameraMove: (position) => {
                    /// UPDATE MAP CAMERA POSITION
                    _singleCompanyMapViewModel.onCameraMove(position),

                    /// UPDATE CLUSTER MANAGER POSITION
                    _clusterManager?.onCameraMove(position),
                  }),

          /// MAP CONTROL
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: MapControlWidget(
                      onZoomInTap: () => _singleCompanyMapViewModel
                          .zoomIn(_googleMapController),
                      onZoomOutTap: () => _singleCompanyMapViewModel
                          .zoomOut(_googleMapController),
                      onShowLocationTap: () => _singleCompanyMapViewModel
                                  .hasPermission &&
                              _singleCompanyMapViewModel.userPosition != null
                          ? _singleCompanyMapViewModel
                              .showUserLocation(_googleMapController)
                          : _singleCompanyMapViewModel.getLocationPermission(),
                      onSearchTap: null))),
        ])));
  }
}
