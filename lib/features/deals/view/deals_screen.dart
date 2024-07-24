import 'package:flutter/material.dart';
import 'package:izowork/features/deals/view_model/deals_view_model.dart';

import 'package:izowork/features/deals/view/deals_screen_body.dart';
import 'package:provider/provider.dart';

class DealsScreenWidget extends StatelessWidget {
  const DealsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DealsViewModel(),
      child: const DealsScreenBodyWidget(),
    );
  }
}
