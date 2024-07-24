import 'package:flutter/material.dart';
import 'package:izowork/features/deal_calendar/view_model/deal_calendar_view_model.dart';
import 'package:izowork/features/deal_calendar/view/deal_calendar_screen_body.dart';
import 'package:provider/provider.dart';

class DealCalendarScreenWidget extends StatelessWidget {
  const DealCalendarScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DealCalendarViewModel(),
      child: const DealCalendarScreenBodyWidget(),
    );
  }
}
