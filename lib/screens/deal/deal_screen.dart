import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/deal/deal_screen_body.dart';
import 'package:provider/provider.dart';

class DealScreenWidget extends StatelessWidget {
  final String id;

  const DealScreenWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealViewModel(id),
        child: const DealScreenBodyWidget());
  }
}
