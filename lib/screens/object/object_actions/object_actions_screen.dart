import 'package:flutter/material.dart';
import 'package:izowork/models/object_actions_view_model.dart';
import 'package:izowork/screens/object/object_actions/object_actions_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectActionsScreenWidget extends StatelessWidget {
  const ObjectActionsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectActionsViewModel(),
        child: const ObjectActionsScreenBodyWidget());
  }
}
