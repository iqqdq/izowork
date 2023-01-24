import 'package:flutter/material.dart';
import 'package:izowork/models/objects_filter_search_view_model.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_search/objects_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectsFilterSearchScreenWidget extends StatelessWidget {
  final int type;
  final VoidCallback onPop;

  const ObjectsFilterSearchScreenWidget(
      {Key? key, required this.type, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectsFilterSearchViewModel(),
        child: ObjectsFilterSearchBodyScreenWidget(type: type, onPop: onPop));
  }
}
