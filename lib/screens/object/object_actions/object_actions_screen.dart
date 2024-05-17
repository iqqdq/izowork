import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/object/object_actions/object_actions_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectActionsScreenWidget extends StatelessWidget {
  final String id;

  const ObjectActionsScreenWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectActionsViewModel(id),
        child: const ObjectActionsScreenBodyWidget());
  }
}
