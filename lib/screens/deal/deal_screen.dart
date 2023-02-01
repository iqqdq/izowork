import 'package:flutter/material.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/models/deal_view_model.dart';
import 'package:izowork/screens/deal/deal_screen_body.dart';
import 'package:provider/provider.dart';

class DealScreenWidget extends StatelessWidget {
  final Deal deal;

  const DealScreenWidget({Key? key, required this.deal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealViewModel(),
        child: DealScreenBodyWidget(deal: deal));
  }
}
