import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/place_model.dart';
import 'package:izowork/views/map_control_widget.dart';
import 'package:izowork/views/map_filter_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:izowork/models/map_view_model.dart';

class MapBodyWidget extends StatefulWidget {
  const MapBodyWidget({Key? key}) : super(key: key);

  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController _googleMapController;
  late MapViewModel _mapViewModel;
  ClusterManager? _clusterManager;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _mapViewModel.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
        _mapViewModel.places, _mapViewModel.updateMarkers,
        markerBuilder: _markerBuilder,
        levels: [1.0, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0]);
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            debugPrint('---- $cluster');
            for (var p in cluster.items) {
              debugPrint(p.name);
            }

            _mapViewModel.showMapObjectSheet(context);
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    num newSize = Platform.isAndroid ? size / 1.25 : size;

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = HexColors.primaryMain;
    final Paint paint2 = Paint()..color = HexColors.white;
    final Paint paint3 = Paint()..color = HexColors.black;

    if (text == null) {
      canvas.drawCircle(
          Offset(newSize / 2, newSize / 2), newSize / 2.5, paint1);
      canvas.drawCircle(
          Offset(newSize / 2, newSize / 2), newSize / 4.0, paint2);
      canvas.drawCircle(
          Offset(newSize / 2, newSize / 2), newSize / 7.0, paint3);
    } else {
      canvas.drawCircle(
          Offset(newSize / 2, newSize / 2), newSize / 2.0, paint1);
      canvas.drawCircle(
          Offset(newSize / 2, newSize / 2), newSize / 2.2, paint2);
      canvas.drawCircle(
          Offset(newSize / 2, newSize / 2), newSize / 2.4, paint1);
    }

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: newSize / 2.0,
            color: HexColors.black,
            fontWeight: FontWeight.w700),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(
            newSize / 2 - painter.width / 2, newSize / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder
        .endRecording()
        .toImage(newSize.toInt(), newSize.toInt());
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _mapViewModel = Provider.of<MapViewModel>(context, listen: true);
    _clusterManager ??= _initClusterManager();

    return SizedBox.expand(
        child: Stack(children: [
      /// GOOGLE MAP
      GoogleMap(
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: _mapViewModel.hasPermission,
          initialCameraPosition: CameraPosition(
            target: _mapViewModel.position ??
                const LatLng(51.1589167131802, 71.4390678226777),
            zoom: 16.0,
          ),
          markers: _mapViewModel.markers,
          onMapCreated: (controller) => {
                _googleMapController = controller,
                _completer.complete(controller),
                _clusterManager?.setMapId(_googleMapController.mapId),

                /// UPDATE LOCATION
                if (_mapViewModel.hasPermission)
                  {
                    _mapViewModel.getUserLocation().then((value) =>
                        _mapViewModel.showUserLocation(_googleMapController))
                  }
              },
          onCameraMove: (position) => {
                /// UPDATE CAMERA POSITION
                _mapViewModel.onCameraMove(position),
                _clusterManager?.onCameraMove
              },
          onCameraIdle: () => {
                _mapViewModel
                    .updatePlaces()
                    .then((value) => {
                          _clusterManager?.onCameraMove,
                          _clusterManager?.setItems(_mapViewModel.places),
                        })
                    .then((value) => _mapViewModel.getAddressName())
              },
          onLongPress: (position) =>
              _mapViewModel.showAddMapObjectSheet(context)),

      /// MAP CONTROL
      Align(
          alignment: Alignment.centerRight,
          child: MapControlWidget(
              onZoomInTap: () => _mapViewModel.zoomIn(_googleMapController),
              onZoomOutTap: () => _mapViewModel.zoomOut(_googleMapController),
              onShowLocationTap: () => _mapViewModel.hasPermission
                  ? _mapViewModel.showUserLocation(_googleMapController)
                  : _mapViewModel.getLocationPermission(),
              onSearchTap: () =>
                  _mapViewModel.showSearchMapObjectSheet(context))),

      /// FILTER BUTTON
      Align(
          alignment: Alignment.bottomCenter,
          child: MapFilterButtonWidget(onTap: () => {}
              // onClearTap: () => {}
              ))
    ]));
  }
}
