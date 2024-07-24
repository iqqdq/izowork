import 'package:flutter/material.dart';
import 'package:izowork/features/recovery/view_model/recovery_view_model.dart';

import 'package:izowork/features/recovery/view/recovery_screen_body.dart';
import 'package:provider/provider.dart';

class RecoveryScreenWidget extends StatelessWidget {
  const RecoveryScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecoveryViewModel(),
      child: const RecoveryScreenBodyWidget(),
    );
  }
}
