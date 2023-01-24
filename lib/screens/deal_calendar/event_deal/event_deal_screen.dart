import 'package:flutter/material.dart';
import 'package:izowork/models/event_deal_view_model.dart';
import 'package:izowork/screens/deal_calendar/event_deal/event_deal_screen_body_widget.dart';
import 'package:provider/provider.dart';

class EventDealScreenWidget extends StatelessWidget {
  final DateTime dateTime;

  const EventDealScreenWidget({Key? key, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EventDealViewModel(),
        child: EventDealScreenBodyWidget(dateTime: dateTime));
  }
}
