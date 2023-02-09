import 'package:flutter/material.dart';
import 'package:izowork/models/objects_filter_view_model.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter/objects_filter_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectsFilterScreenWidget extends StatelessWidget {
  final VoidCallback onManagerTap;
  final VoidCallback onDeveloperTap;
  final VoidCallback onContractorTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ObjectsFilterScreenWidget(
      {Key? key,
      required this.onManagerTap,
      required this.onDeveloperTap,
      required this.onContractorTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectsFilterViewModel(),
        child: ObjectsFilterScreenBodyWidget(
            onManagerTap: onManagerTap,
            onDeveloperTap: onDeveloperTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap,
            onContractorTap: onContractorTap));
  }
}
