import 'package:flutter/material.dart';
import 'package:izowork/features/object/view_model/object_page_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/object/view/object_page/object_page_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectPageScreenWidget extends StatelessWidget {
  final String id;
  final String? phaseId;
  final Function(MapObject?) onPop;

  const ObjectPageScreenWidget({
    Key? key,
    required this.id,
    required this.phaseId,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectPageViewModel(id),
        child: ObjectPageScreenBodyWidget(
          phaseId: phaseId,
          onPop: onPop,
        ));
  }
}
