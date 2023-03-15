import 'package:flutter/material.dart';
import 'package:izowork/entities/response/deal_process.dart';
import 'package:izowork/models/deal_process_view_model.dart';
import 'package:izowork/screens/deal_process/deal_process_screen_body.dart';
import 'package:provider/provider.dart';

class DealProcessScreenWidget extends StatelessWidget {
  final DealProcess dealProcess;

  const DealProcessScreenWidget({Key? key, required this.dealProcess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealProcessViewModel(dealProcess),
        child: const DealProcessScreenBodyWidget());
  }
}
