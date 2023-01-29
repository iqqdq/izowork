import 'package:flutter/material.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/models/object_view_model.dart';
import 'package:izowork/screens/object/object_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectScreenWidget extends StatelessWidget {
  final Object object;

  const ObjectScreenWidget({Key? key, required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectViewModel(),
        child: ObjectScreenBodyWidget(object: object));
  }
}
