import 'package:flutter/material.dart';

import 'package:izowork/models/objects_filter_view_model.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectsFilterPageViewScreenWidget extends StatelessWidget {
  final List<String> options;
  final ObjectsFilter? objectsFilter;

  final Function(ObjectsFilter?) onPop;

  const ObjectsFilterPageViewScreenWidget(
      {Key? key,
      required this.options,
      this.objectsFilter,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectsFilterViewModel(options, objectsFilter),
        child: ObjectsFilterPageViewScreenBodyWidget(onPop: onPop));
  }
}
