import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/deal_event/deal_event_screen_body_widget.dart';
import 'package:provider/provider.dart';

class DealEventScreenWidget extends StatelessWidget {
  final DateTime dateTime;
  final List<Deal> deals;

  const DealEventScreenWidget(
      {Key? key, required this.dateTime, required this.deals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealEventViewModel(deals),
        child: DealEventScreenBodyWidget(dateTime: dateTime));
  }
}
