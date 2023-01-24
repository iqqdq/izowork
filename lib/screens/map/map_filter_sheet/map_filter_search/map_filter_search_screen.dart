import 'package:flutter/material.dart';
import 'package:izowork/models/map_filter_search_view_model.dart';
import 'package:izowork/screens/map/map_filter_sheet/map_filter_search/map_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class MapFilterSearchScreenWidget extends StatelessWidget {
  final int type;
  final VoidCallback onPop;

  const MapFilterSearchScreenWidget(
      {Key? key, required this.type, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MapFilterSearchViewModel(),
        child: MapFilterSearchBodyScreenWidget(type: type, onPop: onPop));
  }
}
