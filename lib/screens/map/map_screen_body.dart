import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/place_model.dart';
import 'package:izowork/screens/map/views/map_control_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:izowork/models/map_view_model.dart';

class MapScreenBodyWidget extends StatefulWidget {
  const MapScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _MapScreenBodyState createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<MapScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController _googleMapController;

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

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
  // MARK: - FUNCTIONS

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
        _mapViewModel.places, _mapViewModel.updateMarkers,
        markerBuilder: _markerBuilder,
        levels: [
          1.0,
          2.0,
          3.5,
          4.5,
          6.75,
          8.25,
          11.5,
          12.5,
          13.0,
          14.5,
          16.0,
          16.5,
          20.0
        ],
        extraPercent: 0.5,
        stopClusteringZoom: 20.0);
  }

  LatLngBounds getBounds(List<LatLng> markers) {
    double minLat = markers.first.latitude;
    double maxLat = markers.first.latitude;
    double minLng = markers.first.longitude;
    double maxLng = markers.first.longitude;

    for (LatLng marker in markers) {
      if (marker.latitude < minLat) {
        minLat = marker.latitude;
      }
      if (marker.latitude > maxLat) {
        maxLat = marker.latitude;
      }
      if (marker.longitude < minLng) {
        minLng = marker.longitude;
      }
      if (marker.longitude > maxLng) {
        maxLng = marker.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            debugPrint('---- $cluster');

            if (cluster.isMultiple) {
              LatLngBounds? bounds = getBounds(cluster.items
                  .map(
                    (marker) => LatLng(
                        marker.location.latitude, marker.location.longitude),
                  )
                  .toList());

              await _googleMapController
                  .animateCamera(CameraUpdate.newLatLngBounds(bounds, 40.0));
            } else {
              await _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(target: cluster.location, zoom: 16.0)));

              Future.delayed(
                  const Duration(milliseconds: 300),
                  () => _mapViewModel.showMapObjectSheet(
                      context, cluster.items.first.id));
            }
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
    _debouncer.run(() => _mapViewModel
        .getObjectList(controller: _googleMapController)
        .then((value) => _mapViewModel.updatePlaces().then((value) => {
              /// UPDATE CLUSTER
              _clusterManager?.setItems(_mapViewModel.places),
              _clusterManager?.updateMap(),
            })));

    double zoom = await _googleMapController.getZoomLevel();

    debugPrint(zoom.toString());
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
                  const LatLng(51.15935891650487, 71.46291020823648),
              zoom: 16.0),
          markers: _mapViewModel.markers,
          onMapCreated: (controller) => {
                _googleMapController = controller,

                /// SET COMPLETER
                _completer.complete(controller),

                /// SET CLUSTER ID
                _clusterManager?.setMapId(_googleMapController.mapId),

                /// UPDATE LOCATION
                _updateMap()
              },
          onCameraMove: (position) => {
                /// UPDATE MAP CAMERA POSITION
                _mapViewModel.onCameraMove(position),

                /// UPDATE CLUSTER MANAGER POSITION
                _clusterManager?.onCameraMove(position)
              },
          onCameraIdle: () => _updateMap(),
          onLongPress: (position) =>
              _mapViewModel.showAddMapObjectSheet(context, position)),

      /// MAP CONTROL
      Align(
          alignment: Alignment.centerRight,
          child: MapControlWidget(
              onZoomInTap: () => _mapViewModel.zoomIn(_googleMapController),
              onZoomOutTap: () => _mapViewModel.zoomOut(_googleMapController),
              onShowLocationTap: () => _mapViewModel.hasPermission &&
                      _mapViewModel.userPosition != null
                  ? _mapViewModel.showUserLocation(_googleMapController)
                  : _mapViewModel.getLocationPermission(),
              onSearchTap: () => _mapViewModel.showSearchMapObjectSheet(
                  context, _googleMapController))),

      /// FILTER BUTTON
      Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: FilterButtonWidget(
                onTap: () => _mapViewModel.showObjectsFilterSheet(
                    context,
                    () => _mapViewModel
                        .getObjectList(controller: _googleMapController)
                        .then((value) => _updateMap())),
                // onClearTap: () => {}
              )))
    ]));
  }
}
