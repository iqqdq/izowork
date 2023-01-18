import 'package:flutter/material.dart';
import 'package:izowork/models/map_filter_view_model.dart';
import 'package:izowork/screens/map/map_filter_sheet/map_filter/map_filter_screen_body.dart';
import 'package:provider/provider.dart';

class MapFilterScreenWidget extends StatelessWidget {
  final VoidCallback onManagerTap;
  final VoidCallback onDeveloperTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const MapFilterScreenWidget(
      {Key? key,
      required this.onManagerTap,
      required this.onDeveloperTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MapFilterViewModel(),
        child: MapFilterScreenBodyWidget(
            onManagerTap: onManagerTap,
            onDeveloperTap: onDeveloperTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
