import 'package:flutter/material.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/models/object_create_view_model.dart';
import 'package:izowork/screens/object_create/object_create_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectCreateScreenWidget extends StatelessWidget {
  final Object? object;
  final Function(Object) onCreate;

  const ObjectCreateScreenWidget(
      {Key? key, this.object, required this.onCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectCreateViewModel(object),
        child: ObjectCreateScreenBodyWidget(onCreate: onCreate));
  }
}
