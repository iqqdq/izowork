import 'package:flutter/material.dart';
import 'package:izowork/models/tab_controller_view_model.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen_body.dart';
import 'package:provider/provider.dart';

class TabControllerScreenWidget extends StatelessWidget {
  const TabControllerScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TabControllerViewModel(),
        child: const TabControllerScreenBodyWidget());
  }
}
