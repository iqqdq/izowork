import 'package:flutter/material.dart';
import 'package:izowork/features/objects/view_model/objects_view_model.dart';

import 'package:izowork/features/objects/view/objects_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectsScreenWidget extends StatelessWidget {
  const ObjectsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ObjectsViewModel(),
      child: const ObjectsScreenBodyWidget(),
    );
  }
}
