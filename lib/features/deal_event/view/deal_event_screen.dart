import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/deal_event/view/deal_event_screen_body_widget.dart';

class DealEventScreenWidget extends StatelessWidget {
  final DateTime dateTime;
  final List<Deal> deals;

  const DealEventScreenWidget({
    Key? key,
    required this.dateTime,
    required this.deals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DealEventScreenBodyWidget(
      dateTime: dateTime,
      deals: deals,
    );
  }
}
