import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/object/object_actions/object_actions_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectActionsScreenWidget extends StatelessWidget {
  final String id;
  final VoidCallback onObjectTraceTap;

  const ObjectActionsScreenWidget({
    Key? key,
    required this.id,
    required this.onObjectTraceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectActionsViewModel(id),
        child: ObjectActionsScreenBodyWidget(
          onObjectTraceTap: onObjectTraceTap,
        ));
  }
}
