import 'package:flutter/material.dart';
import 'package:izowork/models/dialog_view_model.dart';
import 'package:izowork/screens/dialog/dialog_screen_body.dart';
import 'package:provider/provider.dart';

class DialogScreenWidget extends StatelessWidget {
  const DialogScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DialogViewModel(),
        child: const DialogScreenBodyWidget());
  }
}