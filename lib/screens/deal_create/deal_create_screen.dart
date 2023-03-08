import 'package:flutter/material.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/models/deal_create_view_model.dart';
import 'package:izowork/screens/deal_create/deal_create_screen_body.dart';
import 'package:provider/provider.dart';

class DealCreateScreenWidget extends StatelessWidget {
  final Deal? deal;
  final Function(Deal?, List<DealProduct>) onCreate;

  const DealCreateScreenWidget({Key? key, this.deal, required this.onCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealCreateViewModel(deal),
        child: DealCreateScreenBodyWidget(onCreate: onCreate));
  }
}
