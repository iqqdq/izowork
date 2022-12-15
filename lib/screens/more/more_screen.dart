import 'package:flutter/material.dart';
import 'package:izowork/models/more_view_model.dart';
import 'package:izowork/screens/more/more_screen_body.dart';
import 'package:provider/provider.dart';

class MoreScreenWidget extends StatelessWidget {
  const MoreScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MoreViewModel(),
        child: const MoreScreenBodyWidget());
  }
}
