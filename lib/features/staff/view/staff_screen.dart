import 'package:flutter/material.dart';
import 'package:izowork/features/staff/view_model/staff_view_model.dart';

import 'package:izowork/features/staff/view/staff_screen_body.dart';
import 'package:provider/provider.dart';

class StaffScreenWidget extends StatelessWidget {
  const StaffScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StaffViewModel(),
      child: const StaffScreenBodyWidget(),
    );
  }
}
