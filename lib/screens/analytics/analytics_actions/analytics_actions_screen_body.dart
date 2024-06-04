import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/analytics/views/analitics_action_list_item_widget.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/news_page/news_page_screen.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/screens/task/task_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'analytics_actions_filter_sheet/analytics_actions_filter_page_view_screen.dart';

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
  final Pagination _pagination = Pagination(offset: 0, size: 50);

  late AnalyticsActionsViewModel _analyticsActionsViewModel;

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
    _pagination.offset = 0;
    await _analyticsActionsViewModel.getTraceList(pagination: _pagination);
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
                    var trace = _analyticsActionsViewModel.traces[index];

                    return AnalitycsActionListItemWidget(
                        key: ValueKey(trace.id),
                        trace: trace,
                        onTap: () => _onTraceTap(trace));
                  })),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                  onTap: () => _showAnalyticsActionFilterSheet()),
            ),
          ),

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
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showAnalyticsActionFilterSheet() => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => AnalyticsActionsFilterPageViewScreenWidget(
            analyticsActionsFilter:
                _analyticsActionsViewModel.analyticsActionsFilter,
            onPop: (analyticsActionsFilter) => analyticsActionsFilter == null
                ? _analyticsActionsViewModel.resetFilter()
                : _analyticsActionsViewModel.setFilter(analyticsActionsFilter)),
      );

  void _onTraceTap(Trace trace) {
    Widget? screen;

    if (trace.objectId != null) {
      if (trace.phaseId != null) {
        screen = ObjectPageViewScreenWidget(
          id: trace.objectId!,
          phaseId: trace.phaseId,
        );
      } else {
        screen = ObjectPageViewScreenWidget(id: trace.objectId!);
      }
    } else if (trace.dealId != null) {
      screen = DealScreenWidget(id: trace.dealId!);
    } else if (trace.taskId != null) {
      screen = TaskScreenWidget(id: trace.taskId!);
    } else if (trace.newsId != null) {
      screen = NewsPageScreenWidget(id: trace.newsId!);
    }

    if (screen == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen!));
  }
}
