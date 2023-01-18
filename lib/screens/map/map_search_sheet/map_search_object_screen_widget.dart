import 'package:flutter/material.dart';
import 'package:izowork/entities/map_object.dart';
import 'package:izowork/models/map_search_object_view_model.dart';
import 'package:izowork/screens/map/map_search_sheet/map_search_object_screen_body_widget.dart';
import 'package:provider/provider.dart';

class MapSearchObjectScreenWidget extends StatelessWidget {
  final Function(MapObject) onObjectReturn;

  const MapSearchObjectScreenWidget({Key? key, required this.onObjectReturn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MapSearchObjectViewModel(),
        child: MapSearchObjectScreenBodyWidget(onObjectReturn: onObjectReturn));
  }
}
