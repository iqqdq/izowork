import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/map_object/map_object_screen_body_widget.dart';
import 'package:provider/provider.dart';

class MapObjectScreenWidget extends StatelessWidget {
  final MapObject object;
  final bool? hideInfoButton;

  const MapObjectScreenWidget({
    Key? key,
    required this.object,
    this.hideInfoButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MapObjectViewModel(object),
        child: MapObjectScreenBodyWidget(hideInfoButton: hideInfoButton));
  }
}
