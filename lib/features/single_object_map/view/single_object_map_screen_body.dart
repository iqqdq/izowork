import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/features/single_object_map/view_model/single_object_map_view_model.dart';
import 'package:izowork/helpers/helpers.dart';

import 'package:izowork/features/map/view/views/map_control_widget.dart';
import 'package:izowork/features/map_object/view/map_object_screen_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:izowork/models/models.dart';

class SingleObjectMapScreenBodyWidget extends StatefulWidget {
  const SingleObjectMapScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _SingleMapScreenBodyState createState() => _SingleMapScreenBodyState();
}

class _SingleMapScreenBodyState extends State<SingleObjectMapScreenBodyWidget> {
  late GoogleMapController _googleMapController;

  late SingleObjectMapViewModel _singleObjectMapViewModel;
  ClusterManager? _clusterManager;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - CLUSTER FUNCTIONS

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
      _singleObjectMapViewModel.places,
      _singleObjectMapViewModel.updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  Future<Marker> Function(dynamic) get _markerBuilder => (cluster) async {
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
          icon: await MarkerHelper().getObjectMarkerBitmap(
            120,
            cluster,
          ),
        );
      };

  void _updateMap() async {
    _clusterManager?.setItems(_singleObjectMapViewModel.places);
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
          builder: (sheetContext) => MapObjectScreenWidget(
                object: _singleObjectMapViewModel.object,
                hideInfoButton: true,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _singleObjectMapViewModel = Provider.of<SingleObjectMapViewModel>(
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
                  Text(_singleObjectMapViewModel.object.name,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
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
              myLocationEnabled: _singleObjectMapViewModel.hasPermission,
              initialCameraPosition: CameraPosition(
                target: _singleObjectMapViewModel.places.first.latLng,
                zoom: 20.0,
              ),
              markers: _singleObjectMapViewModel.markers,
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
                    _singleObjectMapViewModel.onCameraMove(position),

                    /// UPDATE CLUSTER MANAGER POSITION
                    _clusterManager?.onCameraMove(position),
                  }),

          /// MAP CONTROL
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: MapControlWidget(
                      onZoomInTap: () => _singleObjectMapViewModel
                          .zoomIn(_googleMapController),
                      onZoomOutTap: () => _singleObjectMapViewModel
                          .zoomOut(_googleMapController),
                      onShowLocationTap: () => _singleObjectMapViewModel
                                  .hasPermission &&
                              _singleObjectMapViewModel.userPosition != null
                          ? _singleObjectMapViewModel
                              .showUserLocation(_googleMapController)
                          : _singleObjectMapViewModel.getLocationPermission(),
                      onSearchTap: null))),
        ])));
  }
}
