import 'package:flutter/material.dart';
import 'package:izowork/features/deals/view_model/deals_filter_view_model.dart';

import 'package:izowork/features/deals/view/deals_filter_sheet/deals_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class DealsFilterPageViewScreenWidget extends StatelessWidget {
  final DealsFilter? dealsFilter;

  final Function(DealsFilter?) onPop;

  const DealsFilterPageViewScreenWidget({
    Key? key,
    this.dealsFilter,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DealsFilterViewModel(dealsFilter),
      child: DealsFilterPageViewScreenBodyWidget(onPop: onPop),
    );
  }
}
