import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/deals/deals_screen_body.dart';
import 'package:provider/provider.dart';

class DealsScreenWidget extends StatelessWidget {
  const DealsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealsViewModel(),
        child: const DealsScreenBodyWidget());
  }
}
