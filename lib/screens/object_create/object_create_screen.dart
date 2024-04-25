import 'package:flutter/material.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/models/object_create_view_model.dart';
import 'package:izowork/screens/object_create/object_create_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectCreateScreenWidget extends StatelessWidget {
  final Object? object;
  final String? address;
  final double? lat;
  final double? long;
  final Function(Object?) onPop;

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
