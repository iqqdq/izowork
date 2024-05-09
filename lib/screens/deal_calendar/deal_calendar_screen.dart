import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/deal_calendar/deal_calendar_screen_body.dart';
import 'package:provider/provider.dart';

class DealCalendarScreenWidget extends StatelessWidget {
  const DealCalendarScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealCalendarViewModel(),
        child: const DealCalendarScreenBodyWidget());
  }
}
