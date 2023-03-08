import 'package:flutter/material.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/models/object_view_model.dart';
import 'package:izowork/screens/object/object_page/object_page_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectPageScreenWidget extends StatelessWidget {
  final Object object;
  final VoidCallback onCoordCopy;
  final Function(Object) onUpdate;

  const ObjectPageScreenWidget(
      {Key? key,
      required this.object,
      required this.onCoordCopy,
      required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectPageViewModel(object),
        child: ObjectPageScreenBodyWidget(
            onUpdate: onUpdate, onCoordCopy: onCoordCopy));
  }
}