import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/object/object_page/object_page_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectPageScreenWidget extends StatelessWidget {
  final String id;
  final String? phaseId;
  final VoidCallback onCoordCopy;

  const ObjectPageScreenWidget({
    Key? key,
    required this.id,
    required this.phaseId,
    required this.onCoordCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectPageViewModel(id),
        child: ObjectPageScreenBodyWidget(
          phaseId: phaseId,
          onCoordCopy: onCoordCopy,
        ));
  }
}
