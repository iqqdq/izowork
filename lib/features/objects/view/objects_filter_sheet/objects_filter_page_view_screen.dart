import 'package:flutter/material.dart';
import 'package:izowork/features/objects/view_model/objects_filter_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/objects/view/objects_filter_sheet/objects_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectsFilterPageViewScreenWidget extends StatelessWidget {
  final List<ObjectStage> objectStages;
  final ObjectsFilter? objectsFilter;

  final Function(ObjectsFilter?) onPop;

  const ObjectsFilterPageViewScreenWidget({
    Key? key,
    required this.objectStages,
    this.objectsFilter,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ObjectsFilterViewModel(
        objectStages,
        objectsFilter,
      ),
      child: ObjectsFilterPageViewScreenBodyWidget(onPop: onPop),
    );
  }
}
