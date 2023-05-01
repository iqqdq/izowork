import 'package:flutter/material.dart';
import 'package:izowork/models/object_actions_view_model.dart';
import 'package:izowork/screens/object/object_actions/object_actions_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:izowork/entities/response/object.dart';

class ObjectActionsScreenWidget extends StatelessWidget {
  final Object object;

  const ObjectActionsScreenWidget({Key? key, required this.object})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectActionsViewModel(object),
        child: const ObjectActionsScreenBodyWidget());
  }
}
