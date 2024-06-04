import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/map/map_screen_body.dart';
import 'package:provider/provider.dart';

class MapScreenWidget extends StatelessWidget {
  const MapScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MapViewModel(),
        child: const MapScreenBodyWidget());
  }
}
