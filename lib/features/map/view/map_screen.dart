import 'package:flutter/material.dart';
import 'package:izowork/features/map/view_model/map_view_model.dart';
import 'package:izowork/features/map/view/map_screen_body.dart';
import 'package:provider/provider.dart';

class MapScreenWidget extends StatelessWidget {
  const MapScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapViewModel(),
      child: const MapScreenBodyWidget(),
    );
  }
}
