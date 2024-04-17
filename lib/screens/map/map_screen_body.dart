import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
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
        stopClusteringZoom: 20.0,
        extraPercent: 0.5,
        levels: [
          1.0,
          2.0,
          4.0,
          5.0,
          6.0,
          7.0,
          8.0,
          9.0,
          10.0,
          12.0,
          16.0,
          20.0
        ]);
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
                  .whenComplete(() => _mapViewModel.showMapObjectSheet(
                        context,
                        cluster.items.first.id,
                      ));
            }
          },
          icon: await _getMarkerBitmap(
            cluster.isMultiple ? 160 : 120,
            cluster,
          ),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(
    int size,
    Cluster<Place> cluster,
  ) async {
    double newSize =
        Platform.isAndroid ? size.toDouble() / 1.75 : size.toDouble();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = cluster.items.first.color;
    final Paint paint2 = Paint()..color = HexColors.white;

    final Path path1 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          0.0,
          0.0,
          newSize,
          newSize,
          const Radius.elliptical(10.0, 10.0),
        ),
      );

    final Path path2 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          8.0,
          8.0,
          newSize - 8.0,
          newSize - 8.0,
          const Radius.elliptical(10.0, 10.0),
        ),
      );

    final Path path3 = Path()
      ..addRRect(
        RRect.fromLTRBR(
          16.0,
          16.0,
          newSize - 16.0,
          newSize - 16.0,
          const Radius.elliptical(10.0, 10.0),
        ),
      );

    canvas.drawPath(
      Path.from(path1),
      paint1,
    );

    canvas.drawPath(
      Path.from(path2),
      paint2,
    );

    canvas.drawPath(
      Path.from(path3),
      paint1,
    );

    // LETTER
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    String title1 = cluster.count.toString();
    title1 = title1.length > 3 ? '${title1.substring(0, 2)}...' : title1;
    final String title2 = cluster.items.first.name.substring(0, 1);

    painter.text = TextSpan(
        text: cluster.isMultiple ? title1 : title2,
        style: TextStyle(
          fontSize: cluster.isMultiple
              ? title1.length >= 3
                  ? newSize / 3.0
                  : newSize / 2.0
              : newSize / 2.0,
          color: HexColors.black,
          fontWeight: FontWeight.w600,
          overflow: TextOverflow.ellipsis,
        ));

    painter.layout();

    painter.paint(
        canvas,
        Offset(
          newSize / 2.0 - painter.width / 2.0,
          newSize / 2.0 - painter.height / 2.0,
        ));

    final img = await pictureRecorder.endRecording().toImage(
          newSize.toInt(),
          newSize.toInt(),
        );

    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void _updateMap() async {
    EasyDebounce.debounce('object_debouncer', const Duration(milliseconds: 500),
        () async {
      _mapViewModel
          .getObjectList(controller: _googleMapController)
          .then((value) => _mapViewModel.updatePlaces().then((value) => {
                /// UPDATE CLUSTER
                _clusterManager?.setItems(_mapViewModel.places),
                _clusterManager?.updateMap(),
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _mapViewModel = Provider.of<MapViewModel>(
      context,
      listen: true,
    );
    _clusterManager ??= _initClusterManager();

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
                zoom: 11.0,
              ),
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
                  _mapViewModel.showAddMapObjectSheet(context, position),
            ),

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
                    context,
                    _googleMapController,
                  ))),

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
                      .then(
                        (value) => _updateMap(),
                      ),
                ),
                // onClearTap: () => {}
              )))
    ]));
  }
}
