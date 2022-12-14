import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/models/map_view_model.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/map_control_widget.dart';
import 'package:provider/provider.dart';

class MapBodyWidget extends StatefulWidget {
  const MapBodyWidget({Key? key}) : super(key: key);

  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late GoogleMapController _googleMapController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _mapViewModel = Provider.of<MapViewModel>(context, listen: true);

    return SizedBox.expand(
        child: Stack(children: [
      /// GOOGLE MAP
      GoogleMap(
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: _mapViewModel.hasPermission,
          initialCameraPosition: CameraPosition(
            target: _mapViewModel.location,
            zoom: 16.0,
          ),
          onMapCreated: (controller) => {
                _googleMapController = controller,
                if (_mapViewModel.hasPermission)
                  _mapViewModel.getUserLocation().then((value) =>
                      _mapViewModel.showUserLocation(_googleMapController))
              },
          onCameraMove: (position) =>
              _mapViewModel.updateLocation(position.target),
          onCameraIdle: () => _mapViewModel.onCameraMove()),

      /// MAP CONTROL
      Align(
          alignment: Alignment.centerRight,
          child: MapControlWidget(
              onZoomInTap: () => _mapViewModel.zoomIn(_googleMapController),
              onZoomOutTap: () => _mapViewModel.zoomOut(_googleMapController),
              onShowLocationTap: () =>
                  _mapViewModel.showUserLocation(_googleMapController),
              onSearchTap: () => {})),

      /// FILTER BUTTON
      Align(
          alignment: Alignment.bottomCenter,
          child: FilterButtonWidget(onTap: () => {}))
    ]));
  }
}
