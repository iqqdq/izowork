import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/object_analytics_actions_view_model.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/object_analytics/object_analytics_actions/views/object_analitics_action_list_item_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class ObjectAnalyticsActionsScreenBodyWidget extends StatefulWidget {
  const ObjectAnalyticsActionsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ObjectAnalyticsActionsScreenBodyState createState() =>
      _ObjectAnalyticsActionsScreenBodyState();
}

class _ObjectAnalyticsActionsScreenBodyState
    extends State<ObjectAnalyticsActionsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late ObjectAnalyticsActionsViewModel _objectAnalyticsActionsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _objectAnalyticsActionsViewModel =
        Provider.of<ObjectAnalyticsActionsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          /// ACTION LIST
          ListView.builder(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.bottom),
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                return ObjectAnalitycsActionListItemWidget(
                  dateTime: DateTime.now().add(Duration(days: index)),
                  onTap: () => {},
                );
              }),

          /// INDICATOR
          _objectAnalyticsActionsViewModel.loadingStatus ==
                  LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
