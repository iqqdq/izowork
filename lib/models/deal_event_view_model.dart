import 'package:flutter/material.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/screens/deal/deal_screen.dart';

class DealEventViewModel with ChangeNotifier {
  final List<Deal> deals;

  DealEventViewModel(this.deals);

  // MARK: -
  // MARK: - PUSH

  void showDealScreenWidget(
    BuildContext context,
    int index,
  ) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DealScreenWidget(deal: deals[index])));
}
