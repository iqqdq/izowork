import 'package:flutter/material.dart';
import 'package:izowork/features/object_create/view_model/object_create_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/object_create/view/object_create_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectCreateScreenWidget extends StatelessWidget {
  final MapObject? object;
  final String? address;
  final double? lat;
  final double? long;
  final Function(MapObject?) onPop;

  const ObjectCreateScreenWidget({
    Key? key,
    this.object,
    this.address,
    this.lat,
    this.long,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectCreateViewModel(object),
        child: ObjectCreateScreenBodyWidget(
          address: address,
          lat: lat,
          long: long,
          onPop: onPop,
        ));
  }
}
