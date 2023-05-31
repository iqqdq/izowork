import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/place_model.dart';
import 'package:izowork/models/single_object_map_view_model.dart';
import 'package:izowork/screens/map/views/map_control_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:provider/provider.dart';

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
  // MARK: - FUNCTIONS

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(_singleObjectMapViewModel.places,
        _singleObjectMapViewModel.updateMarkers,
        markerBuilder: _markerBuilder);
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            debugPrint('---- $cluster');

            await _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: cluster.location, zoom: 16.0)));

            Future.delayed(
                const Duration(milliseconds: 300),
                () => _singleObjectMapViewModel.showMapObjectSheet(
                    context, cluster.items.first.id));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75, cluster),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(
      int size, Cluster<Place> cluster) async {
    num newSize = Platform.isAndroid ? size / 1.25 : size;

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = HexColors.primaryMain;
    final Paint paint2 = Paint()..color = HexColors.white;

    canvas.drawCircle(
        Offset(newSize / 2.0, newSize / 2.0), newSize / 2.0, paint1);
    canvas.drawCircle(
        Offset(newSize / 2.0, newSize / 2.0), newSize / 2.2, paint2);
    canvas.drawCircle(
        Offset(newSize / 2.0, newSize / 2.0), newSize / 2.6, paint1);

    TextPainter painter = TextPainter(
        textDirection: TextDirection.ltr, textAlign: TextAlign.center);

    painter.text = TextSpan(
        text: cluster.isMultiple
            ? cluster.count.toString()
            : cluster.items.first.name.substring(0, 1),
        style: TextStyle(
            fontSize: newSize / 2.0,
            color: HexColors.black,
            fontWeight: FontWeight.w700));

    painter.layout();

    painter.paint(
        canvas,
        Offset(newSize / 2.0 - painter.width / 2.0,
            newSize / 2.0 - painter.height / 2.0));

    final img = await pictureRecorder
        .endRecording()
        .toImage(newSize.toInt(), newSize.toInt());
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void _updateMap() async {
    /// UPDATE CLUSTER
    _clusterManager?.setItems(_singleObjectMapViewModel.places);
    _clusterManager?.updateMap();

    Future.delayed(const Duration(seconds: 1), () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    _singleObjectMapViewModel =
        Provider.of<SingleObjectMapViewModel>(context, listen: true);
    _clusterManager ??= _initClusterManager();

    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0.0,
            elevation: 0.0,
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
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: _singleObjectMapViewModel.hasPermission,
              initialCameraPosition: CameraPosition(
                  target: _singleObjectMapViewModel.places.first.latLng,
                  zoom: 11.0),
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
