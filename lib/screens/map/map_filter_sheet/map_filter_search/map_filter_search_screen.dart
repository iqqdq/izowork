import 'package:flutter/material.dart';
import 'package:izowork/models/map_manager_view_model.dart';
import 'package:izowork/screens/map/map_filter_sheet/map_filter_search/map_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class MapFilterSearchScreenWidget extends StatelessWidget {
  final bool isManagerSearch;
  final VoidCallback onPop;

  const MapFilterSearchScreenWidget(
      {Key? key, required this.isManagerSearch, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MapFilterViewModel(),
        child: MapFilterSearchBodyScreenWidget(
            isManagerSearch: isManagerSearch, onPop: onPop));
  }
}
