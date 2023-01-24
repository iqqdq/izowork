import 'package:flutter/material.dart';
import 'package:izowork/models/deals_filter_search_view_model.dart';
import 'package:izowork/screens/actions/deals_filter_sheet/deal_filter_search/deal_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class DealsFilterSearchScreenWidget extends StatelessWidget {
  final int type;
  final VoidCallback onPop;

  const DealsFilterSearchScreenWidget(
      {Key? key, required this.type, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealsFilterSearchViewModel(),
        child: DealFilterSearchBodyScreenWidget(type: type, onPop: onPop));
  }
}
