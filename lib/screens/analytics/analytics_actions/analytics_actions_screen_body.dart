import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/analytics/views/analitics_action_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
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
  final ScrollController _scrollController = ScrollController();

  late AnalyticsActionsViewModel _analyticsActionsViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _analyticsActionsViewModel.getTraceList(pagination: _pagination);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    _analyticsActionsViewModel.getTraceList(pagination: _pagination);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _bottomPadding = MediaQuery.of(context).padding.bottom == 0.0
        ? 12.0
        : MediaQuery.of(context).padding.bottom;

    _analyticsActionsViewModel = Provider.of<AnalyticsActionsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          /// ACTION LIST
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: _bottomPadding + 64.0),
                  shrinkWrap: true,
                  itemCount: _analyticsActionsViewModel.traces.length,
                  itemBuilder: (context, index) {
                    return AnalitycsActionListItemWidget(
                        key: ValueKey(_analyticsActionsViewModel.traces[index]),
                        trace: _analyticsActionsViewModel.traces[index],
                        onTap: () => _analyticsActionsViewModel.showTraceScreen(
                            context, index));
                  })),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                      onTap: () => _analyticsActionsViewModel
                          .showAnalyticsActionFilterSheet(
                              context,
                              () => {
                                    _pagination =
                                        Pagination(offset: 0, size: 50),
                                    _analyticsActionsViewModel.getTraceList(
                                        pagination: _pagination)
                                  })

                      // onClearTap: () => {}
                      ))),

          /// EMPTY LIST TEXT
          _analyticsActionsViewModel.loadingStatus == LoadingStatus.completed &&
                  _analyticsActionsViewModel.traces.isEmpty
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _analyticsActionsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
