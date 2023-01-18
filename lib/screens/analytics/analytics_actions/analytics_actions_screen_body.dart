import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/analytics_actions_view_model.dart';
import 'package:izowork/screens/analytics/views/analitics_action_list_item_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class AnalyticsActionsScreenBodyWidget extends StatefulWidget {
  const AnalyticsActionsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AnalyticsActionsScreenBodyState createState() =>
      _AnalyticsActionsScreenBodyState();
}

class _AnalyticsActionsScreenBodyState
    extends State<AnalyticsActionsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late AnalyticsActionsViewModel _analyticsActionsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _bottomPadding = MediaQuery.of(context).padding.bottom == 0.0
        ? 12.0
        : MediaQuery.of(context).padding.bottom;

    _analyticsActionsViewModel =
        Provider.of<AnalyticsActionsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          /// ACTION LIST
          ListView.builder(
              padding: EdgeInsets.only(bottom: _bottomPadding + 64.0),
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                return AnalitycsActionListItemWidget(
                  dateTime: DateTime.now().add(Duration(days: index)),
                  onTap: () => {},
                );
              }),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                      onTap: () => _analyticsActionsViewModel
                          .showAnalyticsActionFilterSheet(context)

                      // onClearTap: () => {}
                      ))),

          /// INDICATOR
          _analyticsActionsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
