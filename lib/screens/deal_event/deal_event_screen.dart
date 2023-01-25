import 'package:flutter/material.dart';
import 'package:izowork/models/deal_event_view_model.dart';
import 'package:izowork/screens/deal_event/deal_event_screen_body_widget.dart';
import 'package:provider/provider.dart';

class DealEventScreenWidget extends StatelessWidget {
  final DateTime dateTime;

  const DealEventScreenWidget({Key? key, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealEventViewModel(),
        child: DealEventScreenBodyWidget(dateTime: dateTime));
  }
}
